#!/bin/bash

[ "$1" == "nopush" ] && nopush=1

set -e # exit as soon as a command fails
set -a # force export on all vars - needed for envsubst

echo "--> Source the environment file..."
source .env

echo "--> Create container registry $AZ_CONTAINER_REGISTRY_NAME..."
az acr create \
  --resource-group $AZ_RESOURCE_GROUP_NAME \
  --name $AZ_CONTAINER_REGISTRY_NAME \
  --sku $AZ_SKU \
  --output none

echo "--> Enable admin on container registry $AZ_CONTAINER_REGISTRY_NAME..."
az acr update \
  --name $AZ_CONTAINER_REGISTRY_NAME \
  --admin-enabled true \
  --output none

echo "--> Get container registry password..."
export acrPassword=$(az acr credential show \
                  --name $AZ_CONTAINER_REGISTRY_NAME \
                  --query "passwords[0].value"  \
                  | sed 's/"//g')

if [ ! "$nopush" ]
then
  echo "--> Push images to container registry..."
  docker login $AZ_CONTAINER_REGISTRY_NAME.azurecr.io --username $AZ_CONTAINER_REGISTRY_NAME --password $acrPassword
  echo " -- Tag images"
  docker tag ${COMPONENT_NAME_PREFIX}_db:$COMPONENT_VERSION  $AZ_CONTAINER_REGISTRY_SERVER/${COMPONENT_NAME_PREFIX}_db:$COMPONENT_VERSION
  docker tag ${COMPONENT_NAME_PREFIX}_app:$COMPONENT_VERSION $AZ_CONTAINER_REGISTRY_SERVER/${COMPONENT_NAME_PREFIX}_app:$COMPONENT_VERSION
  docker tag ${COMPONENT_NAME_PREFIX}_web:$COMPONENT_VERSION $AZ_CONTAINER_REGISTRY_SERVER/${COMPONENT_NAME_PREFIX}_web:$COMPONENT_VERSION
  echo " -- Push images"
  docker push $AZ_CONTAINER_REGISTRY_SERVER/${COMPONENT_NAME_PREFIX}_db:$COMPONENT_VERSION
  docker push $AZ_CONTAINER_REGISTRY_SERVER/${COMPONENT_NAME_PREFIX}_app:$COMPONENT_VERSION
  docker push $AZ_CONTAINER_REGISTRY_SERVER/${COMPONENT_NAME_PREFIX}_web:$COMPONENT_VERSION
fi
# echo "--> List container registry contents"
# for rep in $(az acr repository list -n $AZ_CONTAINER_REGISTRY_NAME --output tsv)
# do
#   tags=$(az acr repository show-tags -n $AZ_CONTAINER_REGISTRY_NAME --repository $rep --output tsv)
#   echo -e "$rep\t$tags"
# done

# echo "--> Generate database password..."
# dbPassword=$(cat /dev/urandom | tr -dc a-zA-Z0-9 | head -c14)

echo "--> Build container group yaml file (azuredeploy.yml)..."
envsubst < azureContainerDeploy.yml.template >azureContainerDeploy.yml

echo "--> Create container group..."
az container create  \
  --resource-group $AZ_RESOURCE_GROUP_NAME \
  --file azureContainerDeploy.yml \
  --output none

echo "--> Check messages..."
az container show \
  --resource-group $AZ_RESOURCE_GROUP_NAME \
  --name $AZ_CONTAINER_GROUP_NAME \
  | grep message