## Basic concepts about kubectl and deployment a first demo app
### we can make a deploy and manage it with the command line tool kubectl, which use the kubernetes api to interact with the cluster

### One concepts to take into a account is that kubernetes need the application to be packaged into one of the formats of containers supported, like the docker contaienrs. 
### To create a kubernetes deployment we need to specify the image of the application and the number of replicas.

### For this example we take into account that the pods concept refers to a group of one or more containers tied together for administrations and networking purposes. 
### The Kubernete deployment checks the health of the pod and restart the containers if it fials. 

### deploy a sample app and view the logs 
#### Create a deployment to manage the pod that we want to create. 

# Run a test container image that includes a webserver
    kubectl create deployment hello-node --image=registry.k8s.io/e2e-test-images/agnhost:2.39 -- /agnhost netexec --http-port=8080

# to view the deployment 
    kubectl get deployments

# to view the pods 
    kubectl get pods


# view the cluster events
    kubectl get events

# view the kubectl configuration 
    kubectl config view

# to view the app logs for a container in a pod we need his name:
    kubectl logs hello-node-324290fds0

# Service - by default the pods are only accesible by its internal ip addresss within the kubernete cluster. To make the container  accesible from outside the kubernete network, we have to expose the pod through a kubernete service.

# to expose the pod - kubectl expose
    kubectl expose deployment hello-node --type=LoadBalancer --port=8080

# this flag --type=LoadBalancer - indicates that we want to expose the service outside the cluster 

# to view the services 
    kubectl get services

# to clean up 
    kubectl delete service hello-node
    kubectl delete deployment hello-node

# Kubectl basics
## the common format for kubectl command: kubectl [action] [resource]
    kubectl get nodes 

## to check if kubectl is configured - if is installed - have a client a server version 
    kubectl version

## to view the nodes in the cluster - show availables nodes -
    kubectl get nodes