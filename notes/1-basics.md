## containers - refers to the running unit of software - the actual running code and tools (enviroment) required to run the application.

## images - blueprint - the code and the tools (enviroment) required to run the application. 

## the containers are created based on images. We can have one image, and from that image we can have many containers running in the same server or in many servers. When we build an image, we prepare all what we need to run our application, and the container is the actual running unit of sowtfare builded with the code and the enviroment.

## So, containers, are running instances of images. We can have public images, pre-build or existing images and custom images. The public images are supported by the community and the companies behind the specifics tecnologies. The custom, are created for use, and contains all what we need to run our application with all what we need to do that, even using pre-built images to built our own images. 

## The next command, create and run a container based on the specified image, if the image does not exist locally, is downloaded from the docker hub or the specific registry, pulled from the docker hub or registry. 
    docker run node
## The command then run the enviroment of node, run the image as a container, in this case a node image, that runs the node enviroment. Also remember that the containers are isoleted, and in someway we need to expose a port or the medium in which it can communicate with the enviroment to work propperly, but depends from the kind of application that we are trying to run.

## the command shows all the created containers
    docker ps -a 
## the next command runs the container in a interactive mode:
    docker run -it node

## images contains the logic and the code needed to run an application and the container is a running instance of an image, the containers, are created with the run command.

## So, we have the use case, that we have a go or a note.js application that we built and we want to running under a docker enviroment, so in this case, we use a node.js or a go image, we pull that pre-built image, with the neccesary tools to built and run or application inside a container, so, we add our code on top of that our code, so in this way, we create a container with the enviroment and our running code.