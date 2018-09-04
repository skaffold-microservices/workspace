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

