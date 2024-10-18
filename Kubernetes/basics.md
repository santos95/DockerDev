# basics commands using kubectl 
## to list all pods in the current namespace
    kubectl get pods

## creates resources defined in a yml file
    kubectl create -f <file.yml> 
## delete a specific pod
    kubectl delete pod <pod_name> 
## apply changes defined in a YAML file
    kubectl apply -f <file.yaml>

## kubernetes is a open-source container orquestaitor system that allows you to automate the deploy, manage and scaling contenarized application. This plataform make sure that the application runs reliably and efficiently by managing a cluster of containers.

### control pane and nodes
#### Kubernetes manage a highly available cluster of cumputers that works as a single unit - Kubernetes automates the distribution and scheduling of applications containirs in a more efficient way.
#### A kubernetes clusters is made up of: control pane - controls/coordinates the cluster - Nodes that are the Workers, that run the applications

#### control pane 
#### The control pane is responsable to manage the operations of the cluster, such as scheduling applications, maintaining applications desired state, scaling application, rolling out new updates. 

#### Nodes - workers - this are a VM or a machine that works as work machines, which runs a kubelet agent, which enables the machine to run containerized application. The kubelet manage the node and allow the communication with the control plane.

#### The deploy process - when we deploy an application we set the control plane to start application containers -> so the control plane schedule the container to run in the cluster.