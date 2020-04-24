# DockerChallenge

This is a three tier app (web, app, db) created as a learning exercise.

It runs each tier in its own docker container.

## Part 1 - Run it on your local machine

1 - Clone the repo

    git clone https://github.com/marinierb/DockerChallenge.git

2 - cd to it

    cd DockerChallenge

3 - Adjust the contents of the **.env** file to your preferences - the **non-azure** stuff only at this point

4 - Create a **.secrets** file with the following variables - set as required

    POSTGRES_PASSWORD=password123    

5 - Start it

    docker-compose up -d

6 - Test it

URL | Action
--- | ---
http://localhost | Hits the nginx default page
http://localhost/app | Hits the *app* endpoint
http://localhost/users | Hits the *users* endpoint which lists the users in the database

## Part 2 - Deploy it to an Azure Container Group (IaaS)

1 - Adjust the contents of the **.env** file to your preferences - the **azure** stuff only at this point

2 - Log into your Azure account

    az login

3 - Run the deploy script

    ./azuredeploy.sh

4 - Test it - adjust the URL as per the AZ_CONTAINER_GROUP_DNS value

URL | Action
--- | ---
http://brunotestapp.canadacentral.azurecontainer.io/ | Hits the nginx default page
http://brunotestapp.canadacentral.azurecontainer.io/app | Hits the *app* endpoint
http://brunotestapp.canadacentral.azurecontainer.io/users | Hits the *users* endpoint which lists the users in the database


Note
>Could not get postgres to run with a mounted file share.\
>The file share is mounted as root. postgresql runs as postgres.\
>See https://github.com/MicrosoftDocs/azure-docs/issues/16481 \
>So... no persistent storage for the database!\
>On to part 3 then...

## Part 3 - No containers - Deploy the app to App and DB services (PaaS)

* To do

## That's it!