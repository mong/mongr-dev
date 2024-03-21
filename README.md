# An R development environment for mongr projects in a docker container

## Build
Build it yourself from this repository. In the "rstudio" folder, enter the command
```
docker build -t hnskde/mongr-dev .
```
The image will be called "hnskde/mongr-dev", or you can call it something else. 

Alternatively, simply use the image at dockerhub. 

## Use
Open your docker-compose file in the project where you wish to use the image. 
Find the "image" field under the "dev" field, and type in the name of the image. 
When you run docker compose up, the new image will be used. 
