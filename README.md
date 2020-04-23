# DockerChallenge

This is a three tier app (web, app, db) created as a learning exercise.

It runs each tier in its own docker container.

## Part 1 - Run it on your local machine

Clone the repo

    git clone https://github.com/marinierb/DockerChallenge.git

cd to it

    cd DockerChallenge

Create a **.env** file with the following variables - Adjust as required

    COMPONENT_NAME_PREFIX=bruno
    COMPONENT_VERSION=v1.0.0
    # db
    POSTGRES_IMAGE=library/postgres:12.2-alpine
    POSTGRES_HOST=db
    POSTGRES_USER=docker
    POSTGRES_PASSWORD=docker
    POSTGRES_DB=docker
    POSTGRES_PORT=5432
    # app
    NODE_IMAGE=node:13.12.0-alpine3.11
    APP_HOST=app
    APP_PORT=3000
    # web
    NGINX_IMAGE=nginx:1.17.9-alpine
    WEB_PORT=80
    
Start it

    docker-compose up -d

Test it

URL | Action
--- | ---
http://localhost | Hits the nginx default page
http://localhost/app | Hits the *app* endpoint
http://localhost/users | Hits the *users* endpoint which lists the users in the database

## Part 2 - Deploy it to an Azure Container Group (IaaS)

Add the following to your **.env** file - Adjust as required

    # azure
    AZ_RESOURCE_GROUP_NAME=EsSCRaPRg
    AZ_SKU=basic
    AZ_LOCATION=canadacentral
    # IaaS - Container Stuff
    AZ_CONTAINER_REGISTRY_NAME=${COMPONENT_NAME_PREFIX}Acr
    AZ_CONTAINER_REGISTRY_SERVER=${AZ_CONTAINER_REGISTRY_NAME}.azurecr.io
    AZ_CONTAINER_GROUP_NAME=${COMPONENT_NAME_PREFIX}ContainerGroup
    AZ_CONTAINER_GROUP_DNS=${COMPONENT_NAME_PREFIX}testapp

Log into your Azure account

    az login

Run the deploy script

    ./azuredeploy.sh

Test it - Adjust the URL as per the AZ_CONTAINER_GROUP_DNS value

URL | Action
--- | ---
http://brunotestapp.canadacentral.azurecontainer.io/ | Hits the nginx default page
http://brunotestapp.canadacentral.azurecontainer.io//app | Hits the *app* endpoint
http://brunotestapp.canadacentral.azurecontainer.io//users | Hits the *users* endpoint which lists the users in the database

## Part 3 - No containers - Deploy the app to App and DB services (PaaS)

* TBD

## That's it!