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

3. **Install kubectl**:
   - Follow the guide for installing kubectl [here](https://kubernetes.io/docs/tasks/tools/install-kubectl/).

4. **Install Helm**:
   - Follow the guide for installing Helm [here](https://helm.sh/docs/intro/install/).


## Step-by-Step Instructions

### 1. Build the Docker Container

1.  Navigate to the project directory.
2.  Build the Docker image using the following command:

    ```bash
    docker build -t <your-docker-username>/devops-assignment:latest .
    ```

    * This command builds the Docker image and tags it as `<your-docker-username>/devops-assignment:latest`. Replace `<your-docker-username>` with your Docker Hub username or the username of your container registry.

3.  (Optional) Push the Docker image to a container registry (e.g., Docker Hub):

    ```bash
    docker push <your-docker-username>/devops-assignment:latest
    ```

### 2. Deploy the Application and MongoDB using Helm

1.  Navigate to the `k8s-chart` directory.
2.  Install the Helm chart:

    ```bash
    helm install <release-name> ./k8s-chart
    ```

    * This command deploys the application and MongoDB database to your Kubernetes cluster. Replace `<release-name>` with the desired name for your Helm release (e.g., `my-release`).

### 3. Verify the Deployment

1.  Check the status of the MongoDB StatefulSet:

    ```bash
    kubectl get statefulsets <release-name>-mongo
    ```

    * Replace `<release-name>` with your release name.

2.  Check the status of the application Job:

    ```bash
    kubectl get jobs <release-name>-k8s-test
    ```
    * Replace `<release-name>` with your release name.

3.  Check the logs of the `k8s-test` Job to verify successful MongoDB connection:

    ```bash
    kubectl logs <your-k8s-test-pod-name>
    ```

    * Replace `<your-k8s-test-pod-name>` with the name of the Pod created by the Job.

4.  Check the status of the MongoDB Service:

    ```bash
    kubectl get svc mongodb
    ```

## Customizing Deployment Parameters

You can customize the deployment parameters by modifying the `values.yaml` file in the `k8s-chart` directory.

* **MongoDB Image and Tag:**
    * Modify the `mongo.image` and `mongo.tag` values to use a different MongoDB image or tag.
* **MongoDB Storage Size:**
    * Modify the `mongo.storageSize` value to change the persistent volume size for MongoDB.
* **Application Image and Tag:**
    * Modify the `image.repository`, `image.tag`, and `image.pullPolicy` values to use a different application image or tag.
* **MongoDB Service Name:**
    * Modify the `mongo.mongoServiceName` value to change the name of the MongoDB service.
* **Application Node Environment:**
    * Modify the `env.NODE_ENV` to change the node environment.
* **Application resources:**
    * Modify the resources section, to change the memory and cpu requests and limits.

After making changes, upgrade the Helm release:

```bash
helm upgrade <release-name> ./k8s-chart
```