# FIRST DEPLOYMENT 

## THE APP CONSISTE IN A NODE APP WITH TWO ENDPOINTS, THE ERROR WILL MAKE THE APP CRASH TO CHECK AN IMPORTAN FEATURE 

## Deploy to a kubernete cluster - We need a image to run an application - Kubernetes is about containers, for that need a containers. The differents is the deployment, we create the images and kubernetes take care of running them.

### 1 - first creates the image 
    docker build -t kub-fist-app . 

### 2 - create the deployment - Once the image is build, we have to send the image to the kubernete cluster, as part of a pod, part as a deployment which creates the pod and the continers in them. To send the instruction the following commands:

#### 2.1 check if the cluster is up and running
    do