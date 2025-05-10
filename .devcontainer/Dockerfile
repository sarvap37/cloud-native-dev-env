FROM mcr.microsoft.com/devcontainers/base:ubuntu

RUN apt-get update && \
    apt-get install -y curl gnupg2 lsb-release apt-transport-https ca-certificates software-properties-common jq make

# Install kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -sL https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && \
    rm kubectl

# Install kind
RUN curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.20.0/kind-linux-amd64 && \
    chmod +x ./kind && mv ./kind /usr/local/bin/kind

# Install Docker CLI (standalone)
RUN curl -L https://download.docker.com/linux/static/stable/x86_64/docker-24.0.7.tgz | tar -xz && \
    mv docker/docker /usr/local/bin/ && \
    rm -rf docker