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

#### to see the history of our deployments - shows the deployment history - we can see the different deployments. And to see the details about any of them the second command 
    kubectl rollout history deployment/sortiz-first-app
    kubectl rollout history deployment/sortiz-first-app --revision=5 

##### to go back to a specific versioin 
    kubectl rollout undo deployment/sortiz-firt-app --to-revision=1
    
### Declarative approach - using a configuration file
#### in the configuration file, has to be yaml, in that we specify how the deployment will be configured. 
##### In the file we can configure any type of resource, deployment, service and so on. 
##### Which api version to use we can search - 
###### api version - we can use the apps/v1
###### kind - the kind of object we want to configure - for deployment - indicates that we want to configure and create a deployment 
    kind: Deployment
###### metada - to set some required data, like the name of the deployment  
metadata:
    name: second-app-deployment

###### spec - specification of the deployment - set how will be configured 
###### For this example give some info like replicas, container and so on 
###### Inside the template we set the image configuration - below template, we specify a new object, in this case a pod object, so for that we have to define metada for him
spec:
    replicas: 1
    template:
        metadata:
            labels:
                app: second-app
        spec:
            containers:
                - name: second-app
###### by default replicas is set to 1
###### within template - be define the pod that should be created - in the templete of a deployment, always is used to define a pod, so for that, is not necessary to define a kind which the value of pod.
###### after template metadata, we require to define the specification of the inviduals for the deployment that we are defined, The first spec is for the overall deployment and this for the pod 
###### the second spec - define how the pod should be created - so we define one type of pod for a deployment, if we want different types of pods we required other deployments, if we have n replicas we have n equals pods running a container based on the same image.
###### containers key - allows us to define which containers or the single container that should be part of the pod that we are defining. We can define n containers, so remember that a pod can have a group of related containers running. So we can list containers - So containers key allows us to define the container or group of containers that should be part of our pod
###### if we require multiple containers we can define like this - using "-" to specify the different list of containers required.
spec:
            containers:
                - name: first-app-container1
                  image: image1
                - name: first-app-container2
                  image: image2
###### name - So, every container then can have a name - name        
###### image - specify the image that we want to use as we did in the imperative aprouch - kubectl create deployment deployment-name --image=image-name1, image-name2, ... 

###### selector - key concepts in the declaraive aproch
#### to create the deployment - apply a config file to the cluster
kubectl apply -f=deployment.yaml

###### if everything is all right we will have the deployment running
###### in the config file - the selector with in the spec of the deployment and 
###### also the labels within the metadata labels for the template (pod)
###### is very importa, because that tells to kubernetes which pods will be managed
###### or will be part of the specific deployment. 
###### So - selector - match lables - indicates that the pods that have 
###### metadata - labels that match will be part of the deployment, will be 
###### controlled by the deployment - Tells to the deployment which pods will be part of them

###### selectors - allow to specify which other resources will be controlled or connected with the specific resource.


##### service yaml - config file - similar to the deployment config file
###### apiVersion: v1 - is just v1
###### kind: - specify that this is a service kind - because kubernetes ignore the doc file name, specify the type throug the kind
###### metadata: name: define the name that we want to give to the service
###### spec - into the specification - we define the service that we want to create - define and configure the service
###### spec -> selector - the selector here is more flexible that the deployment selector
###### THe selector defines which resources will be controlled or will be part/connected with a specific resource - here, which pods will be controller or be part of the service - services exposes pods
###### Selector - works a bit different - service resources are older, the selector is simple and only support match label, for that 
###### we only defines the label value pair directly without specifying that we use matchlabel as the deployment. 
###### For here, if we have more labels, may be two labels deployment, but 
###### one similar in varios deployments and we can set that this service 
###### will control all pods with that specific pair even if has more - is that flexible.
apiVersion: v1
kind: Service
metadata:
    name: sortiz-second-app-service
spec:
    selector:
        app: second-app
    ports:
        - protocol: 'TCP'
          port: 80
          targetPort: 8080 # this is that the container expose (utilize)
        - protocol: 'TCP'
          port: 20017
          targetPort: 20017
    type: LoadBalancer

    
###### so, with the selector specified about, we tell to kubernetes that
###### this service will expose or group to expose all the pods of a deployment that has the app: second-app label.

###### to specify how the service will expose the pods - in the imperative
###### we define the port and the type (loadBalancer, NodePort...)
###### ports - we can list a list of ports to expose - we define the protocol, the port that we want to expose (machine port) and the port inside the container (map the external with the internal port)

###### type - we specify how the service will expose the pods #
###### ClusterIP - default - internally expose ip - accessible inside only
###### NodePort - Expose on the ip and port of the worker node in which run
###### LoadBalancer - Utilizes the load balancer of the cluster, to get an address accesible outside to make reachable the service and pods exposed by services and distribution of incoming traffic

###### To make changes to our deployment with the yaml files 
###### We only need to change the yaml file with the specific change or configuration we want to modify
###### We re-apply the config file and kubernetes will update our deployment pods and the different objects based on the new version of the file
###### So if we change the image for a new version 
    supermendax95/sortiz-kube-first-app:v4
###### only modify the deployment.yaml and re-apply it - so in this way the changes will be applied to the specific objects 

###### To delete objects generated by the declarative aproch we can do it the same way as the imperative    
    kubectl delete deployment deployment-name
    kubectl delete service service-name
###### and we can also specify the configuration file - kubernete checks for the objects that are defined and will remove them
###### we can remove passing one or many config files - in that way we can instruc kubernete to remove one or multiple objects like services or deployments
    kubectl delete -f 
    kubectl delete -f service.yaml
    kubectl delete -f service.yaml -f deployment.yaml


#### merge files into a single one
##### Previously we have a file for a deployment and one for a service.
##### We can have a single file that contains the configuration of both. 
##### So we can have a single files that contains the instruction to create and manage automatically the worload that we need.
##### So we separate the specif object kind with --- indicating that next coming a new object. So in that way we can separate the service and deployment section
##### Finally, it's recommended to create a service first and then a deployment, so, services keep analyzing the pods that are created and deleted, so it can detect new pods that containes the selector label that match to add that new pod into the service - Join that pod into the group of pod that are exposed by the service.