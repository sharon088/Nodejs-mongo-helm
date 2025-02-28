# DevOps Assignment - Kubernetes Deployment with Helm

## Overview
This project involves containerizing an application, deploying it alongside a MongoDB instance to a local Kubernetes cluster, and orchestrating the deployment using Helm. The goal is to showcase the usage of Docker multi-stage builds, parameterized Helm charts, and reliable deployment strategies (including rolling updates) for a modern microservice application.

## Prerequisites
Before beginning, ensure that the following tools are installed on your machine:
- **Docker**: For building and running containers.
- **Local Kubernetes Cluster**: You can use Minikube, kind, or any other local Kubernetes distribution.
- **kubectl CLI**: For interacting with your Kubernetes cluster.
- **Helm CLI**: For packaging and deploying Helm charts.

### Installation
1. **Install Docker**:
   - Follow the instructions for your OS from the official [Docker installation guide](https://docs.docker.com/get-docker/).

2. **Install Kubernetes**:
   - For Minikube, follow the guide [here](https://minikube.sigs.k8s.io/docs/).
   - For kind, follow the guide [here](https://kind.sigs.k8s.io/docs/).

3. **Install kubectl**:
   - Follow the guide for installing kubectl [here](https://kubernetes.io/docs/tasks/tools/install-kubectl/).

4. **Install Helm**:
   - Follow the guide for installing Helm [here](https://helm.sh/docs/intro/install/).