# workspace

Workspace Containing All Source Code

## Prerequsites

1. Install [Docker4Mac](https://docs.docker.com/docker-for-mac/install/)
1. Install [Skaffold](https://github.com/GoogleContainerTools/skaffold#installation)

### Installing Demo Workspace

```
> make 
```

after which you can access:

1. Go service: `http://localhost/go`
1. Node service: `http://localhost/node`

### Debugging

By default, all services are brought up with `skaffold run` which just starts
the services locally. If you want to work on a specific service, you want to 
start the service in "dev" mode - with code hot-reloading. To do so, just go 
into the service's folder and run `skaffold dev`, e.g.:

```
> cd ms-go-skaffold-demo
> skaffold dev
```