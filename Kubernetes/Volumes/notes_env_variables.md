### with kubernetes we can set enviroment variables 
#### we can set in our code enviroment variables and define it in the manifiest to create a dynamic way of set certain values for our deployments
#### in that way like this example, we set a path which will be used in the code (we set the enviroment variable STORY_FOLDER) to set the path where the data will be stored
#### So, we use kubernete enviroment variables in way that we can set for the pod container the path in which the data will be store for the app
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
        - name: story-app
          image: supermendax95/story-app-data-demo:v3
          volumeMounts: 
            - mountPath: /app/story
              name: story-volume
          env:
            - name: STORY_FOLDER
              value: "story"
      volumes:
        - name: story-volume
          persistentVolumeClaim:
            claimName: host-pvc

### for kubernete we can create also a resource where we can have a list or set of enviroment variables that we can use in other resources
### for that we have the ConfigMap resource where creates a map of config key value pairs 
    apiVersion: v1
    kind: ConfigMap # creates a map of config - key value pairs
    metadata:
    name: data-store-env
    data:
    folder: "story"
### can define as many as is needed nested on the data key:

### so, to references a value into the configmap in our deployment for example:

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
        - name: story-app
          image: supermendax95/story-app-data-demo:v3
          volumeMounts: 
            - mountPath: /app/story
              name: story-volume
          env:
            - name: STORY_FOLDER
              valueFrom:
                configMapKeyRef:
                    name: data-store-env
                    key: folder
      volumes:
        - name: story-volume
          persistentVolumeClaim:
            claimName: host-pvc
### as we can see, to references for the STORY_FOLDER env var we use the valueFrom key to references that we going the use a value from a file
### in this case we set that we use configMapKeyRef, in which we define from which configMap resource will we references throug the name of the resource
### and also we define the key name to get his value from the configMap into our STORY_FOLDER environment variable
### so in this way the set the value from our key value pair: folder: "story" in the environment.yaml file, the value "story: into our environment variable defined in the deployment