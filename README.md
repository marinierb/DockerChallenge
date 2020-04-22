# DockerChallenge

This is a three tier app (web, app, db) created as a learning exercise.

It runs each tier in its own docker container.

## To run it on your local machine

Clone the repo

    git clone https://github.com/marinierb/DockerChallenge.git

cd to it

    cd DockerChallenge

Create a **.env** file with the following variables. Adjust as required.

    COMPONENT_NAME_PREFIX=bruno
    COMPONENT_VERSION=v1.0.0
    # db
    POSTGRES_IMAGE=library/postgres:12.2-alpine
    POSTGRES_HOST=db
    POSTGRES_USER=docker
    POSTGRES_PASSWORD=********
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
    
## To test it

URL | Action
--- | ---
http://localhost | Hits the nginx default page
http://localhost/app | Hits the *app* endpoint
http://localhost/users | Hits the *users* endpoint which lists the users in the database

## That's it!
