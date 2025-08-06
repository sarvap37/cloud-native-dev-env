KIND_CLUSTER_NAME ?= cloud-native-dev


# This Makefile is used to manage the development environment for the cloud-native application
# It uses Kind (Kubernetes in Docker) to create a local Kubernetes cluster
# and Docker to build and run the application
# The application is built using Docker and deployed to the Kind cluster
# The application is a sample cloud-native application that uses Kubernetes and Docker

.PHONY: start-registry kind-up kind-down kind-status build-app app-deploy app-delete registry-status

start-registry:
	docker inspect -f '{{.State.Running}}' kind-registry 2>/dev/null | grep true || \
	docker run -d --restart=always -p 6000:5000 --name kind-registry registry:2
	docker network connect kind kind-registry || true

.PHONY: registry-status

registry-status:
	@echo "🔍 Checking if 'kind-registry' container is running..."
	@docker ps --filter "name=kind-registry"
	@echo "\n🌐 Testing from dev container: curl http://kind-registry:5000/v2/_catalog"
	@curl -sf http://kind-registry:5000/v2/_catalog && echo "✅ Registry is reachable from dev container" || echo "❌ Registry not reachable from dev container"


kind-up: start-registry
	kind delete cluster --name cloud-native-dev || true
	kind create cluster --name $(KIND_CLUSTER_NAME) --config infra/kind-cluster.yaml
	sed -i 's/127.0.0.1/host.docker.internal/' ~/.kube/config



kind-down:
	kind delete cluster --name $(KIND_CLUSTER_NAME)
	docker stop kind-registry >/dev/null 2>&1 || true
	docker rm kind-registry >/dev/null 2>&1 || true

kind-status:
	kubectl cluster-info --context kind-$(KIND_CLUSTER_NAME)

# Build the application using Docker

APP_NAME := sample-app
IMAGE_NAME := sample-app:latest

build-app:
	docker build -t $(IMAGE_NAME) ./$(APP_NAME)
	docker tag $(IMAGE_NAME) localhost:6000/$(IMAGE_NAME)
	docker push localhost:6000/$(IMAGE_NAME) || true

app-deploy:
	kubectl apply -f platform-k8s/

app-delete:
	kubectl delete -f platform-k8s/


