# DockerChallenge

This is a three tier app (web, app, db) created as a learning exercise.

It runs each tier in its own docker container.

## To run it on your local machine

Clone the repo

    git clone https://github.com/marinierb/DockerChallenge.git

cd to it

    cd DockerChallenge

Create a **.env** file with the following variables. Adjust as required.

    POSTGRES_VERSION=12.2-alpine
    NODE_VERSION=13.12.0-alpine3.11
    NGINX_VERSION=1.17.9-alpine
    POSTGRES_USER=docker
    POSTGRES_PASSWORD=********
    POSTGRES_DB=docker
    POSTGRES_PORT=5432
    APP_HOST=app
    APP_PORT=3000
    WEB_PORT=80
    
Start it

    docker-compose up -d
    
## To test it

URL | Action
--- | ---
http://localhost | Hits the nginx default page
http://localhost/app | Hits the *app* endpoint
http://localhost/users | Hits the *users* endpoint which lists the users in the database

## That's it!
