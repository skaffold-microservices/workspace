project:=foo

.PHONY: default
default: start

.PHONY: start
start: 
	- echo "start"

.PHONY: stop
stop: 
	- echo "stop"

.PHONY: setup
setup: nginx-ingress dev-workspace

.PHONY: dev-workspace
dev-workspace:
	#- kubectl apply -f kube-devspace.yml
	- kubectl apply -f kube-ingress-services.yaml

.PHONY: nginx-ingress
nginx-ingress: 
	- kubectl apply -f kube-ingress-nginx-setup.yaml
	- kubectl apply -f kube-ingress-docker4mac.yaml

.PHONY: nginx-ingress-status
nginx-ingress-status:
	- kubectl get pods --all-namespaces -l app.kubernetes.io/name=ingress-nginx --watch

KUBE_INGRESS_CONTROLLER_NAME := $(shell kubectl get pods --namespace=ingress-nginx -l app.kubernetes.io/name=ingress-nginx -o jsonpath='{.items[0].metadata.name}')
.PHONY: nginx-ingress-config
nginx-ingress-config:
	- kubectl -n ingress-nginx exec $(KUBE_INGRESS_CONTROLLER_NAME) -- cat /etc/nginx/nginx.conf

.PHONY: kube-namespaces
kube-namespaces:
	- kubectl get namespaces --show-labels

.PHONY: kube-dashboard-install
kube-dashboard-install: 
	- kubectl create -f https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/recommended/kubernetes-dashboard.yaml

KUBE_DASHBOARD_NAME := $(shell kubectl get pods --namespace=kube-system -l k8s-app=kubernetes-dashboard -o jsonpath='{.items[0].metadata.name}')
.PHONY: kube-dashboard-name
kube-dashboard-name: 
	@echo ${KUBE_DASHBOARD_NAME}

.PHONY: kube-dashboard-route
kube-dashboard-route:
	- kubectl port-forward ${KUBE_DASHBOARD_NAME} 8443:8443 --namespace=kube-system