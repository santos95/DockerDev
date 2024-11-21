# for a kubernete when we try to communicate with containers inside the same pod we can stablish this communication throug the localshot
## remember - services - the type loadBalancer and NodeIp allow to access the deployments (pods) from outside, but by default the communication is clusterip
## So, inside the kubernete network pods can communicate throug the cluster ip - but this does not allow external communication
## because during the pods lifecycle - the ip change 
## so, for that we have services that in a nutshell, provides and stable direction (ip) for the group of pods that are part of that service 
## so, for that also the service has to expose the port in which the apps that are running in containers inside the pod have to be expose
## for the next scenario - we have a deployment - creates a pod with two containers where anyone has a app running that needs communication 
## so, the user-app request data to the auth-app - the service is the only container that has outside access througt the service 
## Only the port 8080 in which the user-app container is listening is publish - the auth-app is only accesible from inside
## in this case, the user-app make a get/post request to a auth-app - how do we stablish the url - address to make the request 
## remember that containers inside the pods, inside the kubernete network can communicate throug the clusterIp, in which in the same pod can communicate each container through the localhost address.
## so in that way, we set a environment variable in which for this case we set localhost as the base address for the user-app to make requests to the auth-app
apiVersion: apps/v1 
kind: Deployment
metadata:
  name: users-app-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      app: users-app
  template:
    metadata:
      labels:
        app: users-app 
    spec:
      containers:
        - name: users-app-container
          image: supermendax95/kub-demo-users:v2
          imagePullPolicy: IfNotPresent
          env:
            - name: AUTH_ADDRESS
              value: localhost
        - name: auth-app-container
          image: supermendax95/kube-demo-auth:v1
          imagePullPolicy: IfNotPresent

--- 

apiVersion: v1 
kind: Service 
metadata:
  name: users-app-service
spec:
  selector: 
    app: users-app
  ports:
    - protocol: 'TCP'
      port: 8080
      targetPort: 8080 
  type: LoadBalancer

  ### so, between two containers inside a pods or more containers inside a pod we can communicate with each other throug the localhost address. But, what happen in a scenario where we need the communication with containers in different pods and one of them is not publish to the outside world, only inside the cluster.
  #### so in this way we need a new service for that deployment in which we define a ClusterIp type, so in that way we gives to the pods on his lifecycle an stable ip-address, so in that way we can stablish communication with him inside the cluster 

##### craetes the auth and user api in the same pod - example 1 internal pods communication - FIRST POD
    # creates the userapp deployment and service
    apiVersion: apps/v1 
    kind: Deployment
    metadata:
    name: users-app-deployment
    spec:
    replicas: 1
    selector:
        matchLabels:
        app: users-app
    template:
        metadata:
        labels:
            app: users-app 
        spec:
        containers:
            - name: users-app-container
            image: supermendax95/kub-demo-users:v2
            imagePullPolicy: IfNotPresent
            env:
                - name: AUTH_ADDRESS 
                #value: localhost - localhost when the communication is inside the same pod - ip address of the service when the communication is between pods
                valueFrom:
                    configMapKeyRef:
                    name: networking-env
                    key: auth-ip-address
                    
    --- 

    apiVersion: v1 
    kind: Service 
    metadata:
    name: users-app-service
    spec:
    selector: 
        app: users-app
    ports:
        - protocol: 'TCP'
        port: 8080
        targetPort: 8080 
    type: LoadBalancer

##### SECOND POD - WITH THE SERVICE WITH THE STABLE IP ADDRESS TO BE ABLE TO STABLISH CONNECTION WITH HIM

# creates the userapp deployment and service - in the user we use a env_variable in which we set the ip that the auth-service generates to be accessed inside the cluster
## we can't access this deployment from outside, only the pods inside the cluster can access.
    apiVersion: apps/v1 
    kind: Deployment
    metadata:
    name: auth-app-deployment
    spec:
    replicas: 1
    selector:
        matchLabels:
        app: auth-app
    template:
        metadata:
        labels:
            app: auth-app 
        spec:
        containers:
            - name: auth-app-container
            image: supermendax95/kube-demo-auth:v1
            imagePullPolicy: IfNotPresent

    --- 

    apiVersion: v1 
    kind: Service 
    metadata:
    name: auth-app-service
    spec:
    selector: 
        app: auth-app
    type: ClusterIP
    ports:
        - protocol: 'TCP'
        port: 80
        targetPort: 80 
    