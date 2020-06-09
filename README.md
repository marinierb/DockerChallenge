[![Build Status](https://dev.azure.com/BrunoMarinier/Test/_apis/build/status/marinierb.DockerChallenge?branchName=master)](https://dev.azure.com/BrunoMarinier/Test/_build/latest?definitionId=1&branchName=master)

# DockerChallenge

This is a three tier app (web, app, db) created as a learning exercise.

It runs each tier in its own docker container.

## Part 1 - Run it on your local machine

1 - Clone the repo

    git clone https://github.com/marinierb/DockerChallenge.git

2 - cd to it

    cd DockerChallenge

3 - Adjust the contents of the **.env** file to your preferences - the **non-azure** stuff only at this point

4 - Start it

    docker-compose up -d

5 - Test it

URL | Action
--- | ---
http://localhost | Hits the nginx default page
http://localhost/app | Hits the *app* endpoint
http://localhost/users | Hits the *users* endpoint which lists the users in the database
http://localhost/dbadminusers | Hits the *adminer* endpoint which redirects to the adminer server

## Part 2 - Deploy it to an Azure Container Group (IaaS)

**:warning: This part uses the images created in step 1. So don't delete them!**

1 - Adjust the contents of the **.env** file to your preferences - the **azure** stuff only at this point

2 - Log into your Azure account

    az login

3 - Run the deploy script

    ./azureContainerDeploy.sh

4 - Test it - adjust the URL as per the AZ_CONTAINER_GROUP_DNS value

URL | Action
--- | ---
http://brunotestapp.canadacentral.azurecontainer.io/ | Hits the nginx default page
http://brunotestapp.canadacentral.azurecontainer.io/app | Hits the *app* endpoint
http://brunotestapp.canadacentral.azurecontainer.io/users | Hits the *users* endpoint which lists the users in the database
http://brunotestapp.canadacentral.azurecontainer.io/dbadmin | Hits the *adminer* endpoint which redirects to the adminer server

## Part 3 - Build and deploy to an Azure Container Group (IaaS) with a pipeline

**:warning: This part uses the container registry created in step 2. So don't delete it!**

1 - To confirm that this works, go to Azure and delete the Container Group

2 - Create a pipeline in Azure that is connected to this github repository

3 - Ensure that the pipeline is set to run the proper pipeline. In the pipeline settings, set:

    YAML file path: azure-pipelines-cg.yml

4 - Push a commit to the repo or just run the pipeline

5 - Test it - adjust the URL as per the AZ_CONTAINER_GROUP_DNS value

URL | Action
--- | ---
http://brunotestapp.canadacentral.azurecontainer.io/ | Hits the nginx default page
http://brunotestapp.canadacentral.azurecontainer.io/app | Hits the *app* endpoint
http://brunotestapp.canadacentral.azurecontainer.io/users | Hits the *users* endpoint which lists the users in the database
http://brunotestapp.canadacentral.azurecontainer.io/dbadmin | Hits the *adminer* endpoint which redirects to the adminer server

## Part 4 - No containers - Deploy the app to App and DB services (PaaS)

* To do

## That's it!