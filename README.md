# DockerChallenge

This is a three tier app (web, app, db) created as a learning exercise.

It runs each tier in its own docker container.

## To run it on your local machine

Clone the repo

    git clone https://github.com/marinierb/DockerChallenge.git

cd to it

    cd DockerChallenge

Create a **.env** file with the following variables. Adjust as required.

    DB_HOST=db
    POSTGRES_USER=docker
    POSTGRES_PASSWORD=password
    POSTGRES_DB=docker
    POSTGRES_PORT=5432
    APP_PORT=3000
    
Start it

    docker-compose up -d
    
## To test it

URL | Action
--- | ---
http://localhost | Hits the reverse proxy default page
http://localhost/app | Hits the *app* endpoint
http://localhost/users | Hits the *users* endpoint which lists the users in the database

## That's it!
