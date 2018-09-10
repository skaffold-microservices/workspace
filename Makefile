project:=foo

ifeq ($(OS),Windows_NT)
	CHECKOUT_BIN:=checkout.exe
else
	UNAME_S:=$(shell uname -s)
	ifeq ($(UNAME_S),Linux)
		CHECKOUT_BIN:=checkout-linux
	endif
	ifeq ($(UNAME_S),Darwin)
		CHECKOUT_BIN:=checkout-mac
	endif
endif

.PHONY: default
default: start

.PHONY: get-fgs
get-fgs:
	cd ./bin && \
	curl -O https://raw.githubusercontent.com/inadarei/faux-git-submodules/master/build/checkout-mac && \
	curl -O https://raw.githubusercontent.com/inadarei/faux-git-submodules/master/build/checkout-linux && \
	curl -O https://raw.githubusercontent.com/inadarei/faux-git-submodules/master/build/checkout-windows && \
	chmod 775 checkout-* && cd --

.PHONY: update
update:
	- @./bin/${CHECKOUT_BIN}

.PHONY: start
start: nginx-ingress services-run services-ingress

.PHONY: stop
stop: 
	- echo "stop"

.PHONY: services-run
services-run:
	- cd ms-go-skaffold-demo && skaffold run && cd -
	- cd ms-node-skaffold-demo && skaffold run && cd -

.PHONY: services-ingress
services-ingress:
	#- kubectl apply -f kube-devspace.yml
	- kubectl apply -f kube-ingress-dashboard.yaml
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

.PHONY: kube-dashboard
kube-dashboard:
	- kubectl port-forward ${KUBE_DASHBOARD_NAME} 8443:8443 --namespace=kube-system