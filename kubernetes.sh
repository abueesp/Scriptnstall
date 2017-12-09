#Install
echo "Pick your right solution and follow the instructions to install https://kubernetes.io/docs/setup/pick-right-solution/"
#Create a node
echo "Create your nodes first, and then, "
#Create daemon
read -p "Write down the route of a daemon.yaml to create it on your nodes: " DAEMON
kuberctl create -f $DAEMON
#Create pod
read -p "Write down the route of you pod.yaml to create it on your daemons: " POD
kubectl create -f $POD
#Choose app
read -p "Write down the route of your app to execute on your pods: " ROUTEAPP
kubectl run app --image $ROUTEAPP
#Create replicas
read -p "Choose the number of replicas: " REPLICAS
kubectl scale deployment app --replicas $REPLICAS
#Open port
read -p "Choose port: " PORT
kubectl expose deployment app --port $PORT --type=LoadBalancer
#Confirm deployment
kubectl get service app
#Confirm availability
read -p "Introduce IP: " IP
curl $IP
echo "Watch your running pods using 'watch -n 1 kubectl get pods'"
#Update app
read -p "Write down the route of the update of your app: " UPDATER
kubectl set image deployment app $UPDATER
