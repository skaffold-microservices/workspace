project:=foo
#KUBE_DASHBOARD:=$(kubectl get pods --namespace=kube-system -l k8s-app=kubernetes-dashboard -o jsonpath='{.items[0].metadata.name}')
KUBE_DASHBOARD:=kubernetes-dashboard-7b9c7bc8c9-nfsk2

.PHONY: default
default: start

.PHONY: start
start: 
	- echo "start"

.PHONY: stop
stop: 
	- echo "stop"

.PHONY: dev-workspace
dev-workspace:
	- kubectl apply -f kube-devspace.yml

.PHONY: dev-ingress
dev-ingress: 
	#- kubectl 
	- kubectl apply -f kube-ingress.yaml
	#- kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/provider/cloud-generic.yaml

.PHONY: kube-namespaces
kube-namespaces:
	- kubectl get namespaces --show-labels

.PHONY: kube-dashboard-install
kube-dashboard-install: 
	- kubectl create -f https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/recommended/kubernetes-dashboard.yaml

.PHONY: kube-dashboard-route
kube-dashboard-route:
	- kubectl port-forward ${KUBE_DASHBOARD} 8443:8443 --namespace=kube-system
	- @echo ${KUBE_DASHBOARD}
	- @echo ${project}
