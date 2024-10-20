# FIRST DEPLOYMENT 

## THE APP CONSISTE IN A NODE APP WITH TWO ENDPOINTS, THE ERROR WILL MAKE THE APP CRASH TO CHECK AN IMPORTAN FEATURE 

## Deploy to a kubernete cluster - We need a image to run an application - Kubernetes is about containers, for that need a containers. The differents is the deployment, we create the images and kubernetes take care of running them.

### 1 - first creates the image 
    docker build -t kub-fist-app . 

### 2 - create the deployment - Once the image is build, we have to send the image to the kubernete cluster, as part of a pod, part as a deployment which creates the pod and the continers in them. To send the instruction the following commands:

#### 2.1 check if the cluster is up and running
    kubectl get deployments
    kubectl get nodes

#### To instruct to the kubernete cluster to create objects like deployments which will manage our deployment, also services and other objects - We use kubectl command - tool that sends instruction to the crontrol plane, that instruct to create or manage that objects 

#### 3 creates the deployment 
    kubectl create deployment first-app --image=kub-first-app

####  the last command works, but kubernetes will have problems because will not be able to pull the image, that the image that we refers is a local image. So we need to specify from where kubernetes will pull the image, a registry.

#### So, to avoid that problem. push the image to a registry
    docker login 
    docker build -t sortiz-kube-first-app .
    docker tag sortiz-kube-first-app supermendax95/sortiz-kube-first-app:v1
    docker push supermendax95/sortiz-kube-first-app:v1
    kubectl create deployment sortiz-first-app --image=supermendax95/sortiz-kube-first-app:v1

#### so, in this way kubernetes is able to pull the image and sucessfully creates the deployment, pods..

#### check the deployment
    kubectl get deployments 
    kubectl get pods

### Creates the service - expose a pod created by a deployment by createing a service - Requires at least three parameters, the deployment name, port that need to expose and the type - the type can be ClusterIp which only expose the pod internally by the ip address, will be unchangable, the NodePort which will expose externally using the ip address of the worker node, and The LoadBalancer, which will use a Load Balancer, which have to exists in the cluster, which will generate a unique address for the service and also evently distributed incoming traffic to pods for this service.
    kubectl expose deployment sortiz-first-app --port=8080 --type=LoadBalancer
#### with this we can access our applicion, which is running in a container which is running in a pod that was created by kubernete based on the deployment that we created and sended to the kubernete cluster


### Restarting - when we create a deployment we also able the next behavior respect to our app running in a container running in a pod in a node.
#### for the application running, if we requeste /error the app will stop which makes the container fails or crash. So, the status here will be error and eventually kubernete restart the container in the pod, which is monitor, if fails is restarted. Kubernete monitor the health of the container in the pod, if fails or crash, try to restart the container recreating them. Self-healing mechanism

### Replicas - we can modify the behavior or our deployment, if we dont define/set autoscaling, so will no creates more or less pods.
#### We can modify the behavior of our deployment respect for the number of instances of our application running to balance traffic - when the traffic increase we can create more instances to manage the new traffict.
#### so we know that more traffic is comming we can scale our app to more pods or instances to manage new traffict:
    kubectl scale deployment/sortiz-first-app --replicas=3 

#### so this will create new pods to satisfy the new deployment scale configuration. So, with:
    kubectl get pods 
#### we will have three pods running a container based on the same images, in which the load balancer will distribute the traffic amoung the three. 
#### so, if one of the pods crash, the app will be up running because the load balancer will direct the traffic to the availables running apps on the pods up and running.
#### in this scenario the traffics goes down and we don't require the three pods running, only one 
    kubectl scale deployment/sortiz-first-app --replicas=1

### Change code and rollback
#### change code - change the source code and create a new image that reflext the change.
    docker build -t sortiz-kube-first-app .
    docker tag sortiz-kube-first-app supermendax95/sortiz-kube-first-app:v2
    docker push supermendax95/sortiz-kube-first-app:v2
##### to update the image for a deployment to a new version - tell kubernetes that we set a new image for a specific deployment - deployment/name-of-deployment, and we also have to specify to kubernete which current container and image have to be updated with new one - we need to pass the name of the container
    kubectl set image deployment/deployment-name container=image-url
    kubectl set image deployment/sortiz-first-app sortiz-kube-first-app=supermendax95/sortiz-kube-first-app:v2

##### reminder - if we no use tags, the image will not be updated by default. So, with the default setting we have to use tags to version. In my case a tagged the image v1, v2 and so on, and has to work. if detects that is a different version kubernetes download the image and restart the container based on the new image. The different tag trigger kubernetes to redownload the image.
##### so in that way we can update the source code on a container application running as part of a pod managed by kubernete

### command to view the current status - this command also tells you what actually going on, this command enter into a interactive session that keeps listening whats going on.
    kubectl rollout status deployment/sortiz-first-app
### to check the events - we can see that downoload the image and create a new pod with a container based on a new image
    kubectl events 

##### rollbacks - if we have problem when try to start a new container with updates image (source code) and the pod fails, the rolling update strategy that kubernete uses do not shut down the previous pod until the new one is up and running.
##### if we have a problem during the deployment so we can undo - go back to the previous version - to test a wrote a bad images name so can be downloaded and the deployment of the new pod fails - the pod fails, but the previos version still up and running. 
    kubectl rollout status deployment/sortiz-first-app
    kubectl rollout undo deployment/sortiz-first-app




