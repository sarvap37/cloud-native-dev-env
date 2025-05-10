# Cloud Native Dev Environment

This repo sets up a portable development environment with:

- Dev Container
- Local Kind Kubernetes Cluster

## 🔧 Requirements

- Docker
- VS Code (or any editor with Dev Containers support)
- [GitHub CLI](https://cli.github.com/) (optional)

## 🚀 Usage

1. Open this folder in VS Code
2. Reopen in Container when prompted
3. Cluster will be created automatically via `make kind-up`

## 🧹 Cleanup

```bash
make kind-down
