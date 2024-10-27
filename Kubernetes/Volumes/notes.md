# Volumes
## When we working with docker to persist the state, data that is used and created by our application we need to persist it to keep the value of our application.

## With docker, to avoid data lost we restart/remove containers - we use volumes 
## Volumes creates a path into the local machine in which the data is stored by the containers.
## The data persist and still available even when the containers restart/remove

## We can approach something like that with kubernetes - but with a different
## With docker in the docker run or docker-compose we set the volume for the application, for kubernete
## we need to instruct kubernete to create a volume 

## In kubernet - volumes is a more powerfull feature, allowing many different drivers and types
## in Kubernete, the persist is not by default, because the containers are running into pods, so the volumes too
## When the container is restarted or replaced, the volume persist, but if the pod is replaced the volumes is lost too
## So, is possible to avoid that, but requires a feature to te able.

## In docker, volumes do not support driver and type - is just a directory into the file system of the local machine, and persist until 
## the user manually deletes the directory or reset the operate system