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