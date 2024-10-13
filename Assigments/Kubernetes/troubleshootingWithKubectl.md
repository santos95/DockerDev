# Troubleshooting with kubectl - the next command allows to know what the current state are, what they are running and what configurations are in application that were deployed
## list resources
    kubectl get
## show detailed info about resources 
    kubectl describe
## print logs from a container in a pod
    kubectl logs
## execute a command on a container in a pod 
    kubectl exec 

## Check app configuration 
### check if an application is running
    kubectl get pods 
### to get information ffrom inside a pod - show what images are used to build, ip address, ports used and a lis of eventes related with the lifecycle of the pod
    kubectl describe pods 

## view container logs - we can also specify the container name 
    kubectl logs pod_name 
## executing commands on the container - we can execute commands on the container directly, with the exec command and use the pod name as a parameter 
    kubectl exec "$POD_NAME" -- env

## start a bash session in the pods container
    kubectl exec -ti pod_name -- bash
