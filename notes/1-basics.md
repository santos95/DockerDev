## containers - refers to the running unit of software - the actual running code and tools (enviroment) required to run the application.

## images - blueprint - the code and the tools (enviroment) required to run the application. 

## the containers are created based on images. We can have one image, and from that image we can have many containers running in the same server or in many servers. When we build an image, we prepare all what we need to run our application, and the container is the actual running unit of software builded with the code and the enviroment.

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

## DOCKER FILES
### The docker files are setup files, with instruction for docker, that we wanna execute when we built our own image. Contains setup instruccion to built our image.

### Remember, the container (also the image) contains the code + enviroment to run the application. 

FROM node

COPY . . 

RUN npm install

EXPOSE 3000

CMD  [ "node", "app.js" ]

### The docker file starts with the FROM command, that refers to an image to use it as base image to build our own image. In this case refers to a node image, and this node image, if not exists locally, is pulled from the docker hub or from our own registry. When a image is pulled, is stored locally, cached locally. 

### The COPY command, has two parameters, the fist one, refer to the path in our system, referying to a folders, subfolders and files in our system to be copied into the image. The second one refer to a path inside the image, where the files will be copied. So this COPY . ., copy all the folders, subfolders and files in our workdir, in this case where the docker files is, to the image. So the first one, is the path in our system where exists the folders and files to be copied to the image and the second one, the path into the image where the folders and files will be copied.

### The RUN command, will executed the specified command into the image, but, relative to the working directory. Remember, the image (containers) has their own file system, detached from the system where you are curring setting up the docker file. So, the run command, will run in this case, in the root folder. All the commands will run relative to the root, to change that, we can use the WORKDIR command, which specified the working directory, and all the next command will run relative to the workdir. 

FROM node

WORKDIR /app

COPY . . 

RUN npm install

EXPOSE 80

CMD  [ "node", "server.js" ]

### So in this case, the copy run relative to the /app, the files are stored into the image in the /app folder. To be more explicit we can specife the absolote path, but is the same. So all the commands followed after the workdir command are executed relative to the /app 

### So the above command in our docker file are setup command to built our image, FROM, WORKDIR, RUN, EXPOSE, so, with this command we are setting up the dependencies and the code into our image to be used to create or built a container based on that image. We copy the files with the app code, and also the dependencies needed, we download the dependencies (rmp install), at the end, the CMD command, execute a command, similar to run, but with the diffent that is executed when we create a container based on the image, so the momment when we actually we want out application running. If we use the command RUN node server.js what we actually doing is trying to run the node server into our image, the template, and that is not what we want, because the image is not what we run in the end, is a container based on a image.

### The EXPOSE commands, remember that the container is isolated, which means, in this case, the app is running listen on the port 80 inside our container, but in this case, our local machine is not able to reach that, because by default the container do not expose the port, and for that, we are not listening in that port in our system. So with the EXPOSE command, once we have setting up, and before the CMD command, which have to be the last command, we are setting the container to expose the port, so in that way able to listen in our local machine listen on that port, the machine in which we are running the container.

### RUNNING A CONTAINER BASED ON A OWN IMAGE
#### Once we have our docker file with the instruction to build our own image, we have to build an image based on that docker file, and then create a container based on the image with all the code and dependencies to run our application. For that we need: 
    docker build /path/to/docker/file
#### if we are in the same folder as the docker file:
    docker build . 

#### Once the image is builded, we can create a container based on that image: 
    docker run image_id

#### In we only create a container with the last command and we need to listen to the local system in a required port, the container will not work properly, because the EXPOSE do not really expose the port to the local machine, work more like a documentation command, that indicates which port has to be exposed to listen. To this demo dockerized app works properly we have to execute something like this:
    docker run -p 80:80 
#### The option -p, refers to port to be publish from our container to our local machine. In this case expose the port 80 in the container and map it to the port 80 in the local machine. So, the application is a web server, so in this way, the container will run and listening incoming connection. http://localhost:80. If we browse this in our browser will get the application that is running in our container. THe command docker run, keep executing because is a web server. To stop the application and the container in which the application is runnning:
    docker stop container_id
    docker stop container_name

#### To remove a image we can use this command:
    docker rmi image_name
    docker rmi image_id

#### To remove a container:
    docker rm container_name
    docker rm container_id

### LAYER BASE
#### Images are layer base, every instruction represent a layer when the image is builded. Every layer can be cached, which means that when re-build an image, docker can detect which layer has a change, so if the three first layers are the same, will use the cache and the process will be faster, an only will execute from scratch from the instruction in which a change was detected. So in this next Docker file:
FROM node

WORKDIR /app

COPY . . 

RUN npm install

EXPOSE 80

CMD  [ "node", "server.js" ]

#### So here, every instruction represent a layer, the last one instruction, is the extra layer that is executed when we create a container based on a image. So, here, our source code, every time we create a container based on that image, the code and the envirment will be the same, because when we copy the files and code, is like a snapshot of that files in the moment in which we create the image. So if for example, if we change code, and we create a container based on that image the change will not be reflected. So in this case we have to re-built the image with the new changes. So in the docker file instructions before, if we change the code, the starting from COPY command, docker will rebuilt that layers from scratch, even if the dependencies are the same. If we want in this example optimize the process of built of the image for our custom image, we can do something like this:
FROM node 

WORKDIR /app

COPY package.json .

RUN npm install 

COPY . /app/

EXPOSE 80 

CMD [ "node", "server.js"]

#### In this last example, we copy the package.json first and then run the command to download the dependencies. So, if we change the source code and rebuilt our image, for the layer COPY package.json and RUN docker will use the cache and the process will be faster. Only in cases when we include new dependencies this layers will be builded from scratch. 

#### So remember, layers are cached, docker can detect in some levels changes, and if do not detect some change in some layers will no rebuilt from scratch, and only will rebuilt from scratch from the layer in which a change is detected and the next layers. \

    
### Managing images and containers.
#### docker commands:
#### List all active contaienrs:
docker ps 
#### List all active/exited containers:
docker ps -a
#### The docker run command create or instance a new contaiener based on a image, so to restart a container which is stopped:
docker start container_id
#### To stop a container:
docker stop container_id
#### Attachmend - The default behavior for docker run is attached mode, in which the terminal keep listening for the logs of our container. The docker start the default is dettached, so the container is running underground, and we can check it with docker ps command.
##### attach a restarted container, so in this way we can attach to a container.:
docker run container_id
docker attach container_id
##### to run a container with detached mode:
docker run -d
##### Another way to attach to the outputs of our running containers is the docker logs command, which by default shows us the logs the outputs written for that container, but not keep listening for new entries. So to keep listening the logs use the -f option for the docker logs command :
docker logs container_id
docker logs -f container_id
#### To start a stopped container in attach mode we can:
docker start -a container_id






### Interactive Mode
#### to practice - dockerize a python app that needs to run into a interactive mode. Creates the docker file to tun the app:

# use the base python image
FROM python 

# set /app as the working directory
WORKDIR /app 

# copy all the content in the local directory to /app
COPY . /app

# execute the app with the python executable
CMD ["python", "rng.py"]

