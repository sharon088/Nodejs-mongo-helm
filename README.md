# DevOps Assignment - Docker & Kubernetes Deployment

## Overview

This project demonstrates how to build and deploy a microservice application with Docker and Kubernetes. It involves the following components:
1. **Docker Containerization** - The provided application is containerized using a multi-stage Dockerfile.
2. **Kubernetes Deployment with Helm** - The application and MongoDB are deployed to a local Kubernetes cluster using Helm.
3. **Rolling Updates and Service Connectivity** - The deployment strategy supports rolling updates and ensures connectivity between the application and MongoDB service.

## Prerequisites

Before you begin, ensure that you have the following installed:
- **Docker**: For building and running containers.
- **Kubernetes Cluster**: Minikube, kind, or any local Kubernetes distribution.
- **kubectl**: For interacting with your Kubernetes cluster.
- **Helm**: For packaging and deploying Helm charts.

Additionally, you will need access to the application source files (`src/devops-assignment-index.html`, `docker-test.js`, `k8s-test.js`), and the required `start.sh` script.

## Setup Instructions

### Part 1: Docker Containerization

The Dockerfile uses a multi-stage build to containerize the provided application.

#### Steps to Build the Docker Container:
1. **Clone the repository** (if not already done).
2. **Navigate to the directory** containing the `Dockerfile`.
3. **Build the Docker image**:
    ```bash
    docker build -t devops-assignment:latest .
    ```
4. **Verify the build**:
    ```bash
    docker images
    ```

#### Dockerfile Overview:
- **Stage 1 (Build Stage)**: Installs application dependencies and prepares the source files.
- **Stage 2 (Final Stage)**: Includes required system packages (e.g., `bash`, `curl`, `vim`, etc.), creates a user/group, and copies the necessary files to the container.
- **Start Script**: The `start.sh` script is executed to start the application.

### Part 2: Kubernetes Deployment with Helm

Helm is used to package and deploy both the application and MongoDB.

#### Deploying MongoDB and the Application:
1. **Install Helm** (if not installed):
    ```bash
    curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
    ```
2. **Package the Helm chart**:
    Navigate to the `k8s-chart` directory and run:
    ```bash
    helm package .
    ```
3. **Deploy MongoDB**:
    The MongoDB StatefulSet and Service are defined in the `k8s-chart/mongo` folder. To deploy MongoDB, run:
    ```bash
    helm install mongodb ./k8s-chart
    ```

4. **Deploy the Application**:
    The application is defined in the `k8s-chart/app/deployment.yaml`. You can deploy the app with the following command:
    ```bash
    helm install app ./k8s-chart
    ```

5. **Verify the Deployment**:
    Once the app and MongoDB are deployed, use `kubectl` to verify:
    ```bash
    kubectl get pods
    kubectl get services
    ```

### Part 3: Customizing the Deployment

The Helm chart allows for several parameters to be customized in the `values.yaml` file. You can modify these parameters to suit your needs.

#### Key Customizable Parameters:
- **replicaCount**: Number of app replicas to run.
- **image**: Specifies the Docker image repository and tag.
- **imagePullPolicy**: Defines when Kubernetes should pull the image (`IfNotPresent` by default).
- **NODE_ENV**: Environment variable for setting the application’s environment (production by default).
- **Resources**: CPU and memory requests/limits for the app.
- **Rolling Updates**: Managed via Kubernetes' deployment strategy (see below).

#### Example to Modify the Number of Replicas:
Modify the `values.yaml`:
```yaml
replicaCount: 3
```