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
### hostPath - instead of using emptyDir which creates an empty directory into the pod - here we create or use a path in the file system of the host machine - allowing to multiple pods running (replicas) to share the same volume (allow to read from and write to the same file) - this advantage reduce the pod portability by making the pod tied to the host. Because the data is stored in specific host. With emptyDir we have a specific pod volume, where if the pod is recreated or remove the data is loss, in this case, hostPath the data turns into a node specific, making the data only available in the specific host machine.
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
### advantage: direct access to the host filesystem from the containers, useful to accessing systemfiles, hardware devices and other node-specific data and simple to use (provide shared resources between the host and containers)
### disadvantages: Tightly couples the pod and a specific node, making the node less portable, risk of overwriting/modify sensitive data on host, not suitable for highly available or distributed systems, as the data turns into specific to a single node and not replicated across the cluster.
#### The required key value parameters to define: The path key value, that refers Path on the host machine where the data will be stored - path: - refers to a path in the local machine file system where data (volume) will be stored - will be mapped (like bind mount with the containers running in the pods) 
#### So, the path is similar to a bind mounts in docker, where bind a specific path on the host machine to a internals containers in pods
#### the other key value pair is the type, which indicates the type of directory or file the pod expect. So, allow to define more specific validation and security on the mounted file or directory
#### posible values: Directory (expect a directory if not fails), File, DirectoryOrCreate (if not existes create it), FileOrDirectory, Socket, CharDevice, BlockDevice
volumes:
        - name: shared-data
          hostPath: {}