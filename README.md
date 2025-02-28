# DevOps Assignment - Application Deployment with MongoDB

This document outlines the steps to build, deploy, and customize the application and MongoDB database using a Helm chart. It also explains key design decisions and how the solution meets the assignment requirements.

## Setup and Prerequisites

Before you begin, ensure you have the following installed:

* **Docker:** To build the Docker image.
* **Kubernetes (e.g., Minikube, kind, or a cloud-based Kubernetes cluster):** To deploy the application.
* **Helm:** To manage the Kubernetes deployment.
* **kubectl:** To interact with the Kubernetes cluster.
* **Node.js and npm:** To run the application and tests.

## Step-by-Step Instructions

### 1. Build the Docker Container

1.  Navigate to the project directory.
2.  Build the Docker image using the following command:

    ```bash
    docker build --build-arg K8S_TEST_PATH=src/k8s-test.js --build-arg DOCKER_TEST_PATH=src/docker-test.js -t sharon088/devops-assignment:latest .
    ```

    * This command builds the Docker image and tags it as `sharon088/devops-assignment:latest`.
    * `--build-arg` is used to pass the location of the test files, to the helm charts.

3.  (Optional) Push the Docker image to a container registry (e.g., Docker Hub):

    ```bash
    docker push sharon088/devops-assignment:latest
    ```

### 2. Deploy the Application and MongoDB using Helm

1.  Navigate to the `k8s-chart` directory.
2.  Install the Helm chart:

    ```bash
    helm install my-release ./k8s-chart
    ```

    * This command deploys the application and MongoDB database to your Kubernetes cluster.

### 3. Verify the Deployment

1.  Check the status of the MongoDB StatefulSet:

    ```bash
    kubectl get statefulsets my-release-mongo
    ```

2.  Check the status of the application deployment:

    ```bash
    kubectl get jobs my-release-k8s-test
    ```

3.  Check the logs of the `k8s-test` Job to verify successful MongoDB connection:

    ```bash
    kubectl logs <your-k8s-test-pod-name>
    ```

    * Replace `<your-k8s-test-pod-name>` with the name of the Pod created by the Job.

4. Check the status of the mongo service:

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
    * Modify the `mongoServiceName` value to change the name of the mongodb service.

After making changes, upgrade the Helm release:

```bash
helm upgrade my-release ./k8s-chart