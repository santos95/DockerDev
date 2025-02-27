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

## so, volumes are attached to pods - there are created in the pods specification into the yaml deployment manifest:
### first - emptyDir type - This type of volume - creates an empty directory that can be mount in a specific location into the container 
    spec:
        containers:
            - name: story-app
            image: supermendax95/story-app-data-demo:v2
            volumeMounts: 
                - mountPath: /app/story
                name: story-volume
        volumes:
            - name: story-volume
            emptyDir:  {}

### in the pod specifications - we define the volume with a name and the type, in this case an empty directory with the default configuration 
### once we have the volume, we set in the containers configuration the volumeMounts - to set the place into the container where the volume will be mounted
### for this case - set the mountPath - the path in the container where will be mounted and the name of the volume
### the mountPath depends of the app, the path in which the app is set to read/write data 
### the empty directory type - the deployment creates and empty directory tied to the pod, and keeps the dir alive and filled with date as long as the pod is alive
### Name helps - because we can have n containers that can mount this volume in a different directories or may be different volumes that need to be mounted
### this type of volume - creates and empty directory where data can be stored temporary - because is tied to a pod - if a pod is removed the data also is removed
### helps - share data between containers in the pod
### so all the containers in the same pod can read/write to this volume 
    spec:
    containers:
    - name: app-container
        image: my-app-image
        volumeMounts:
        - mountPath: /mnt/data
          name: shared-data
    - name: sidecar-container
        image: my-sidecar-image
        volumeMounts:
        - mountPath: /mnt/data
          name: shared-data
    volumes:
        - name: shared-data
          emptyDir: {}
### hostPath - instead of using emptyDir which creates an empty directory into the pod - here we create or use a path in the file system of the host machine - 
### allowing to multiple pods running (replicas) to share the same volume (allow to read from and write to the same file) - this advantage reduce the pod portability 
### by making the pod tied to the host. Because the data is stored in specific host. With emptyDir we have a specific pod volume, where if the pod is recreated or 
### remove the data is loss, in this case, hostPath the data turns into a node specific, making the data only available in the specific host machine.
### Also, hostPath also make possible to share existing data like config files, logs or something like that to the pods and the running application on them. 
### Use Cases - log sharing - to write logs on the host specific path on the host machine
    volumes:
    - name: logs
    hostPath:
        path: /var/log/containers
        type: Directory
### Mounting docker socket - Some tools or monitoring systems require access to the Docker socket on the host.
    volumes:
     - name: docker-socket
       hostPath:
          path: /var/run/docker.sock
          type: Socker
### Shared configuration file - A configuration file or secret could be stored on the host machine and shared with the containers for consistent configuration
    volume:
     -name: config
      hostPath:
        path: /etc/config
        type: File
### advantage: direct access to the host filesystem from the containers, useful to accessing systemfiles, hardware devices and other node-specific data and simple to use
### (provide shared resources between the host and containers)
### disadvantages: Tightly couples the pod and a specific node, making the node less portable, risk of overwriting/modify sensitive data on host, not suitable 
### for highly available or distributed systems, as the data turns into specific to a single node and not replicated across the cluster.
#### The required key value parameters to define: The path key value, that refers Path on the host machine where the data will be stored 
### - path: - refers to a path in the local machine file system where data (volume) will be stored - will be mapped (like bind mount with
###  the containers running in the pods) 
#### So, the path is similar to a bind mounts in docker, where bind a specific path on the host machine to a internals containers in pods
#### the other key value pair is the type, which indicates the type of directory or file the pod expect. So, allow to define more specific validation and 
### security on the mounted file or directory
#### posible values: Directory (expect a directory if not fails), File, DirectoryOrCreate (if not existes create it), FileOrDirectory, Socket, CharDevice, BlockDevice
volumes:
        - name: shared-data
          hostPath: {}

### Persistent volumes 
#### the persistent volumes allow us to make our data independent from the pods and event the nodes.
#### So in that way we can persist our data even again pods removal and recreation, allowing also to have pods into different nodes sharing specific data, 
### allowing to persist that data - allowing to have a pod been created in any node and also n replicas read/write into the same specific storage location,
###  in that way persist data beyond pods and nodes. 
### As deployment and services and many things in kubernete, persistent volumes are resources 
### To define and use persitent volumes in our pods we need to define two resources 
### The persistent volume 
### - this is a resource that defines the kind of storage - the sysadmin provition a resource that we use to create this resource, with a purpose and 
### specific behavior to take care of specific storage scenarios
### the persistent volume claim 
### - this kind of resource claims or request for a specific kind of persitent volume - define the requirements for a persistent volumes
### once we have the persistent volume and the persistent volume claim, we use the persistent volume claim in our pods specification to allow the use
###  of persistent volumes in our pods and in that way persist our data beyond pods and nodes specifics.


### Persistent volume - a way to manage storage resources independently of a individual pods - allows to persist data beyond the pods lifecycle 
### - persist after pods restart, delete and reschedule on a different node - is a way to abstract or decople storage from nodes allowing to persist 
### data beyound pods and nodes.

#### persistent volumes are cluster-wide resources - are not bound to any specific pod or namespace - are available for any pod and resource on a namespace

#### create a persistent volume 
apiVersion: v1
kind: PersistentVolume
metada:
    name: host-pv
spec:
    capacity:
        storage: 1Gi
    volumeMode: Filesystem
    accessModes:
        - ReadWriteOnce
    hostPath:
        path: /data
        type: DirectoryOrCreate

#### as any other resource in kubernete we define the apiversion and the kind of resource, we give a name and define the specification,
###  for this case for a dev-practice enviroment we use the hostPath, that will allow to create a detached volume resourced from any pod, 
### but in this case not from nodes (in practice, this practice the esentials can work from any other type of full detached from pods and nodes type)
#### persistent volumes is not like normal volumes - for this we have to define other parameters
#### the capacity - set the overall available capacity of the persistent volume - define how much capacity can provide this volume to the different pods 
#### running that claims storage capacity from this volume 
#### to set the capacity - capacity key value - storage key value
spec:
capacity:
    storage: 4Gi
volumeMode: Filesystem
storageClassName: standart
AccessModes:
    - ReadWriteOnce

#### indicates that up of 4Gi can be claimed and used by this hostPath volume
#### volumeMode - define different storageTypes - Block Storage and Filesystem (this is not just for kubernete is global)
#### AccessModes - the different type of access mode - the way in how this volume will be claimed and used for pods 
### - this set how this volume will be allowed to be claimed - three types (ReadWriteOnce, ReadOnlyMany, ReadWriteMany) 
### - we can set one or many (or even all) - which mean when we create and use a volumeClaim in which we define what kind of accessMode volume
###  we need and set for our pods to claim - we set how the running app in the pod will use this volume 
#### ReadWriteOnce - can be mounted as read-write by a single node (one or multiple pods in the same node)
#### ReadOnlyMany - can be mounted or claimed as read only by a multiple node
#### ReadWriteMany - can be mounted or claimed as read-write by a multiple nodes (one or many pods from multiple nodes can claim and use this volume)

#### this have to be checked if is available for the kind of persitentVolume that we are creating - for hostPath only the ReadWriteOnce is available

#### different pods can use the same persisten volume, but to use it, we need a resource - persistent volume claim

#### define a persistent volume claim - everything is a resource in kubernete
    apiVersion: v1
    kind: PersistentVolumeClaim
    metadata:
        name: host-pvc
    spec:
        volumeName: host-pv
        accessModes:
            - ReadWriteOnce
        storageClassName: standart
        resources:
            requests:
                storage: 1Gi
    

#### for the pv and pvc we have to define the storageClassName that define how the PV and PVc will be provisioned dynamically by kubernete
#### tell to kubernete how to manage and automate the provision of persistent storage resources like PV
#### define how the will be binding, the provisioner (backend or storage provider), reclaim policy (what happend when the PV is released) etc - in the enviroment of dockerdesktop by default the class is defined to work a lab - the standart
#### in the PVc is defined to tell kubernete (request) a storage recource that match that class

##### Similar to other resources we define the api version and the kind
##### for documentation and use purpose we give to it a name
##### The spec we define the parameters to reach or use a persitentvolume 
##### We define the required parameters that we are requesting or claiming that our app needs.
##### ex: storage capacity, type of accessMode, type of volume mode and so on
#### volumeName: host-pv - simply indicates that this persistent volume claim will request the Pv host-pv - another way, to direct select the required volume
#### in a production enviroment we can have many persistent volumes 
#### so using the flexibility of kubernete we can select one of them by a process in which kubernete finds out the first one that fullfit the requirements that are defined in the PVc
#### static provisioning - in which direct define the volume to use
#### dynamic volume provisioning - in which is the volume is selected or claimed by resources. 
#### in the PVc - 
#### volumeName: host-pv - allows us to select a PV to use by name
#### accessModes: To define the access modes that will be availables 
#### modos that we want to use by claim volume - in the example ReadWriteOnce. We can define in the claim multiple access modes for the claim
#### resources - counter part of PV capacitity
#### request: storage: inside the request - request capacity - 
#### for the claim we have to request the max or less of the total capacity of the PV
#### but, if we have multiple claims to the same PV we might want to request less of the available to avoid get errors when try to use this claims in our pods when they try to write more than the available capacity

#### the PVs are used by pods to make a claim (request) to a PV and get its Volume

    apiVersion: apps/v1 
    kind: Deployment
    metadata:
    name: story-app-deployment 
    spec:
    replicas: 1
    selector:
        matchLabels:
        app: story-app
    template:
        metadata:
        labels:
            app: story-app
        spec:
        containers:
            - name: story-app-container
            image: supermendax95/story-app-data-demo:v2
            volumeMounts: 
                - mountPath: /app/story
                  name: story-volume
        volumes:
            - name: story-volume
              persistentVolumeClaim:
                claimName: host-pvc

##### in the deployment.yaml - we define in the volumes key the name of the volume and we use 
### the persistentVolumeClaim - claimName - to select the PVc to use 
##### so in this way we can access to a volume throught the claim
##### A PVc can be used in different type of pods 


###### to request the storageClasses, PVs and PVc
    kubetl get sc
    kubectl get pv
    
