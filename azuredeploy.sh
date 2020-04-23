#!/bin/bash

set -e # exit as soon as a command fails

echo "--> Source the environment file"
# envsubst (below) needs vars to be exported, so...
set -a   # force export on all vars
source .env
set +a   # put things back the way they were

## Could not get postgres to run with a mounted file share
## The file share is mounted as root. postgresql runs as postgre
## See https://github.com/MicrosoftDocs/azure-docs/issues/16481
# echo "--> Create storage account for database"
# az storage account create \
#   --resource-group $AZ_RESOURCE_GROUP_NAME \
#   --name $AZ_STORAGE_ACCOUNT_NAME \
#   --location $AZ_LOCATION \
#   --sku $AZ_STORAGE_ACCOUNT_SKU \
#   --output none

# echo "--> Create file share for database"
# az storage share create \
#   --name $AZ_FILE_SHARE_NAME \
#   --account-name $AZ_STORAGE_ACCOUNT_NAME \
#   --output none

# echo "--> Get the store account key"
# export storageAccountKey=$(az storage account keys list \
#                         --resource-group $AZ_RESOURCE_GROUP_NAME \
#                         --account-name $AZ_STORAGE_ACCOUNT_NAME \
#                         --query "[0].value" --output tsv)

echo "--> Create container registry"
az acr create \
  --resource-group $AZ_RESOURCE_GROUP_NAME \
  --name $AZ_CONTAINER_REGISTRY_NAME \
  --sku $AZ_SKU \
  --output none

echo "--> Enable admin on container registry"
az acr update \
  --name $AZ_CONTAINER_REGISTRY_NAME \
  --admin-enabled true \
  --output none

echo "--> Get container registry password"
export acrPassword=$(az acr credential show \
                  --name $AZ_CONTAINER_REGISTRY_NAME \
                  --query "passwords[0].value"  \
                  | sed 's/"//g')

echo "--> Push images to container registry"
docker login $AZ_CONTAINER_REGISTRY_NAME.azurecr.io --username $AZ_CONTAINER_REGISTRY_NAME --password $acrPassword
echo " -- Tag images"
docker tag ${COMPONENT_NAME_PREFIX}_db:$COMPONENT_VERSION  $AZ_CONTAINER_REGISTRY_SERVER/${COMPONENT_NAME_PREFIX}_db:$COMPONENT_VERSION
docker tag ${COMPONENT_NAME_PREFIX}_app:$COMPONENT_VERSION $AZ_CONTAINER_REGISTRY_SERVER/${COMPONENT_NAME_PREFIX}_app:$COMPONENT_VERSION
docker tag ${COMPONENT_NAME_PREFIX}_web:$COMPONENT_VERSION $AZ_CONTAINER_REGISTRY_SERVER/${COMPONENT_NAME_PREFIX}_web:$COMPONENT_VERSION
echo " -- Push images"
docker push $AZ_CONTAINER_REGISTRY_SERVER/${COMPONENT_NAME_PREFIX}_db:$COMPONENT_VERSION
docker push $AZ_CONTAINER_REGISTRY_SERVER/${COMPONENT_NAME_PREFIX}_app:$COMPONENT_VERSION
docker push $AZ_CONTAINER_REGISTRY_SERVER/${COMPONENT_NAME_PREFIX}_web:$COMPONENT_VERSION

# echo "--> List container registry contents"
# for rep in $(az acr repository list -n $AZ_CONTAINER_REGISTRY_NAME --output tsv)
# do
#   tags=$(az acr repository show-tags -n $AZ_CONTAINER_REGISTRY_NAME --repository $rep --output tsv)
#   echo -e "$rep\t$tags"
# done

echo "--> Build container group yaml file (azuredeploy.yml)"
envsubst < azuredeploy.yml.template >azuredeploy.yml

echo "--> Create container group"
az container create  \
  --resource-group $AZ_RESOURCE_GROUP_NAME \
  --file azuredeploy.yml \
  --output none

echo "--> Check messages"
az container show \
  --resource-group $AZ_RESOURCE_GROUP_NAME \
  --name $AZ_CONTAINER_GROUP_NAME \
  | grep message