#Install
echo "Pick your right solution and follow the instructions to install https://kubernetes.io/docs/setup/pick-right-solution/"
#Choose app
read -p "Write down the route of your app to create it: " ROUTEAPP
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
#Create daemon
read -p "Write down the route of a daemon.yaml: " DAEMON
kuberctl create -f $DAEMON
#Create pod
read -p "Write down the route of you pod.yaml: " POD
kubectl create -f $POD
