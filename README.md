# workspace

Workspace Containing All Source Code

## Prerequsites

1. Docker4Mac
1. Skaffold
1. Run `make update`

### Run services

The `make update` will checkout node and go microservices in `ms-*`
folders. To start them as Skaffold services you can do one of two things:

1. Go into the corresponding folder and run `skaffold dev` if you want to run
the  microservice in the interactive, hot-reloading mode. Typically you only
want to run the service that you are actively working on, in this mode

2. Go into the corresponding folder and run `skaffold run` if you just need
the microservice to be up (e.g. as a dependency for something else)


### Setup

```
> make setup
```

### Usage

1. Go service: `http://localhost/go`
1. Node service: `http://localhost/node`