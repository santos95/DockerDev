# kubernete objects 
## kubernete service
### Object that expose pods internally and externally. Allow pods to be accesible from inside (other pods in the cluster) and outside the cluster 
### by default pods has his own ip address - can't be used to reach a pod inside the cluster and change when a pod is replaced (making hard to reach a pod inside).
### So services - group a set of pods together with a shared ip - that ip is reachable and unchangable - Can be exposed inside and outside, making the pod and the application accesible from inside (cluster) and external. Default - internal only
