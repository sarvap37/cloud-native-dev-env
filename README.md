# Cloud Native Dev Environment

This repository provides a complete portable development environment for cloud-native applications using Kubernetes. It includes:

- **Dev Container** - Consistent development environment across different machines
- **Kind Kubernetes Cluster** - Local Kubernetes cluster running in Docker
- **Container Registry** - Local Docker registry for image management
- **Sample FastAPI Application** - Example cloud-native Python application
- **Kubernetes Manifests** - Deployment, service, and troubleshooting resources

## 🏗️ Architecture

The setup includes:
- **Kind cluster** with custom configuration for local development
- **Local registry** (`localhost:6000`) for container image storage
- **Sample Python FastAPI app** demonstrating cloud-native patterns
- **Kubernetes resources** for deployment and networking
- **Debugging tools** via troubleshooting pod

## 🔧 Requirements

- **Docker** - For running containers and Kind cluster
- **VS Code** (or any editor with Dev Containers support)
- **Make** - For running automation commands
- **kubectl** - Kubernetes command-line tool (included in dev container)
- **Kind** - Kubernetes in Docker (included in dev container)

## 🚀 Quick Start

### 1. Setup Environment
```bash
# Open this folder in VS Code
# Reopen in Container when prompted
```

### 2. Create Kubernetes Cluster
```bash
# Start the Kind cluster with local registry
make kind-up

# Check cluster status
make kind-status
```

### 3. Build and Deploy Sample Application
```bash
# Build the sample FastAPI application
make build-app

# Deploy to Kubernetes
make app-deploy

# Access the application at http://localhost:31000
```

## 📋 Available Commands

| Command | Description |
|---------|-------------|
| `make kind-up` | Create Kind cluster with local registry |
| `make kind-down` | Delete Kind cluster and registry |
| `make kind-status` | Check cluster status |
| `make start-registry` | Start local Docker registry |
| `make registry-status` | Check registry status |
| `make build-app` | Build and push sample application |
| `make app-deploy` | Deploy application to Kubernetes |
| `make app-delete` | Remove application from Kubernetes |

## 🔍 Accessing the Application

Once deployed, the sample FastAPI application is available at:
- **Local access**: http://localhost:31000
- **API endpoint**: GET / returns `{"message": "Hello from Saravana Kubernetes"}`

## 🛠️ Troubleshooting

### Debug Pod
A troubleshooting pod with network tools is available:
```bash
kubectl apply -f platform-k8s/troubleshooting-pod.yaml
kubectl exec -it debug -- bash
```

### Check Registry
```bash
make registry-status
```

### View Application Logs
```bash
kubectl logs -l app=sample
```

## 📁 Project Structure

```
├── Makefile                           # Automation commands
├── README.md                          # This file
├── infra/
│   └── kind-cluster.yaml             # Kind cluster configuration
├── platform-k8s/
│   ├── deployment.yaml               # Kubernetes deployment
│   ├── services.yaml                 # Kubernetes service (NodePort)
│   └── troubleshooting-pod.yaml      # Debug pod with network tools
└── sample-app/
    ├── Dockerfile                    # Container image definition
    └── main.py                       # FastAPI application
```

## � Technical Details

### Cluster Configuration
- **Cluster Name**: `cloud-native-dev`
- **Port Mappings**: Port 31000 is mapped from host to cluster
- **Registry Integration**: Containerd is configured to use the local registry
- **API Server**: Configured with `host.docker.internal` for dev container access

### Application Specifications
- **Framework**: FastAPI (Python 3.11)
- **Container Port**: 8080
- **Service Type**: NodePort (port 31000)
- **Image Repository**: `localhost:6000/sample-app:latest`

### Registry Details
- **Container Name**: `kind-registry`
- **Host Port**: 6000
- **Internal Port**: 5000
- **API Endpoint**: http://kind-registry:5000/v2/_catalog

## 🔍 Verification Steps

### Check Everything is Running
```bash
# Verify cluster
kubectl cluster-info

# Check nodes
kubectl get nodes

# Verify application
kubectl get pods -l app=sample
kubectl get services

# Test registry
make registry-status

# Access application
curl http://localhost:31000
```

## 🐛 Common Issues

### Registry Connection Issues
If you see image pull errors:
```bash
# Restart registry
make start-registry
# Rebuild and redeploy
make build-app
make app-deploy
```

### Port Already in Use
If port 31000 is busy:
```bash
# Check what's using the port
netstat -tulpn | grep 31000
# Stop conflicting services or change nodePort in services.yaml
```

### Cluster Access Issues
If kubectl commands fail:
```bash
# Recreate cluster
make kind-down
make kind-up
```

## �🧹 Cleanup

```bash
# Remove application from cluster
make app-delete

# Delete entire cluster and registry
make kind-down
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test the complete workflow
5. Submit a pull request

## 📝 License

This project is open source and available under the [MIT License](LICENSE).
