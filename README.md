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


## Part 1: Docker Containerization

### Objective

We created a multi-stage Dockerfile for building and deploying the application.

### Steps to Build the Docker Container

1.  **Navigate to the root directory** of the project.
2.  **Build the Docker image** using the following command:

    ```bash
    docker build -t <your-docker-username>/devops-assignment:latest .
    ```

    This command will build a Docker image using the multi-stage Dockerfile. The first stage installs dependencies, and the second stage prepares the final container by copying over the necessary files, installing required packages, and setting up user permissions. Replace `<your-docker-username>` with your Docker Hub username or the username of your container registry.

3.  **Push the Docker image to a container registry (e.g., Docker Hub):**

    ```bash
    docker push <your-docker-username>/devops-assignment:latest
    ```

    This command pushes the built Docker image to a container registry, making it accessible to your Kubernetes cluster.

### Dockerfile Breakdown

* **Stage 1: Build Stage**
    * Uses `node:23-alpine` as the base image.
    * Sets the working directory to `/app`.
    * Copies `package.json` and installs dependencies using `npm install`.
    * Copies the application source code (`src`) and `start.sh` script.
    * This stage focuses on building the application and its dependencies.
* **Stage 2: Final Stage**
    * Uses `node:23-alpine` as the base image again, creating a clean environment.
    * Installs required packages (`ca-certificates`, `bash`, `vim`, `procps`, `curl`).
    * Creates a user and group (`appuser`) with ID 1500 to run the application securely.
    * Copies `node_modules` and other application files from the first stage.
    * Sets up the required environment and permissions for the `start.sh` script.
    * Exposes port 8080 and runs the application via the `start.sh` script.
    * This stage creates the final, minimal Docker image for deployment.

## Part 2: Kubernetes Deployment with Helm

### Objective

We deployed the application and MongoDB database to a Kubernetes cluster using a Helm chart to simplify management and customization.

### Steps to Deploy the Application and MongoDB using Helm

1.  **Navigate to the `k8s-chart` directory.**
2.  **Install the Helm chart** using the following command:

    ```bash
    helm install <release-name> ./k8s-chart
    ```

    This command deploys the application and MongoDB database to your Kubernetes cluster. Replace `<release-name>` with the desired name for your Helm release (e.g., `my-release`).

### Helm Chart Breakdown

* **`values.yaml`:**
    * Contains configuration values for the deployment, such as image names, tags, ports, resource limits, and replica counts.
    * Allows for easy customization of the deployment without modifying the template files directly.
    * Serves as the single source of truth for all configurable parameters.

* **`Chart.yaml`:**
    * Defines metadata about the Helm chart, such as its name, version, and description.
    * Manages chart dependencies and versioning.

* **`templates/` Directory Structure:**
    * Contains Kubernetes manifest templates that are rendered by Helm.

    * **`templates/common/`**
        * `serviceaccount.yaml`: Creates a service account for Pods, enabling controlled access to the Kubernetes API.

    * **`templates/mongo/`**
        * `mongo-service.yaml`: Defines a Kubernetes Service to expose the MongoDB StatefulSet, allowing network access to the database.
        * `mongo-statefulset.yaml`: Creates a StatefulSet for deploying MongoDB, ensuring data persistence and stable network identities.

    * **`templates/app/`**
        * `deployment.yaml`: Defines a Deployment for the application, managing Pod replicas and updates.
        * `service.yaml`: Defines a Kubernetes Service to expose the application.
        * `k8s-test-mongo-job.yaml`: Defines a Job to run the `k8s-test.js` script, verifying MongoDB connectivity.
        * `hpa.yaml`: Defines a HorizontalPodAutoscaler to automatically scale the application.
        * `ingress.yaml`: Defines an ingress for the application.

    * **`templates/tests/`**
        * `test-connection.yaml`: Provides a basic test connection configuration (provided by Helm).

* **Key Template Explanations:**

    * **MongoDB Service (`mongo-service.yaml`):**
        * Exposes the MongoDB database as a Kubernetes Service, allowing the application to connect to it using the service name.
        * Uses `ClusterIP` as the default service type.

    * **MongoDB StatefulSet (`mongo-statefulset.yaml`):**
        * Ensures data persistence and consistent network identities for MongoDB Pods.
        * Uses Persistent Volume Claims (PVCs) to store MongoDB data.
        * Allows for dynamic scaling of MongoDB replicas via `values.yaml`.

    * **Application Deployment (`deployment.yaml`):**
        * Manages the deployment of the application Pods.
        * Uses environment variables (e.g., `NODE_ENV`) to configure the application.
        * Supports rolling updates for seamless deployment changes.

    * **Application Job (`k8s-test-mongo-job.yaml`):**
        * Runs the `k8s-test.js` script to verify MongoDB connectivity.
        * Ensures the test script runs to completion and then terminates.
        * Uses environment variables to pass the MongoDB service name to the test script.

* **Environment Variables:**
    * Used to pass configuration data (like the MongoDB service name) to the application and test scripts.
    * The `MONGO_SERVICE_NAME` environment variable is passed to the `k8s-test.js` script, ensuring dynamic service name resolution.

## Verification, Customization, Rolling Updates, and Service Connectivity

### 3. Verify the Deployment

1.  Check the status of the MongoDB StatefulSet:

    ```bash
    kubectl get statefulsets <release-name>-mongo
    ```

2.  Check the status of the application Job:

    ```bash
    kubectl get jobs <release-name>-k8s-test
    ```

3.  Check the logs of the `k8s-test` Job to verify successful MongoDB connection:

    ```bash
    kubectl logs <your-k8s-test-pod-name>
    ```

4.  Check the status of the MongoDB Service:

    ```bash
    kubectl get svc mongodb
    ```

### Customizing Deployment Parameters

You can customize the deployment parameters by modifying the `values.yaml` file in the `k8s-chart` directory.

Here are some examples of parameters you can customize:

* **Application Replicas:**

    ```yaml
    replicaCount: 1
    ```

    * **Explanation:** To scale the application deployment, change the `replicaCount` value. For example, `replicaCount: 3` will create three replicas of your application Pods.

* **MongoDB Replicas:**

    ```yaml
    mongo:
      replicas: 1
    ```

    * **Explanation:** To scale the MongoDB StatefulSet, change the `replicas` value. For example, `replicas: 3` will create three MongoDB Pods. Note that MongoDB clustering requires additional configuration.

* **MongoDB Image and Tag:**

    ```yaml
    mongo:
      image: mongo
      tag: "7.0.17"
    ```

    * **Explanation:** To use a different MongoDB version, change the `tag` value (e.g., `tag: "6.0"`). To use a different MongoDB image, change the `image` value.

* **MongoDB Storage Size:**

    ```yaml
    mongo:
      storageSize: 1Gi
    ```

    * **Explanation:** To increase or decrease the storage size, modify the `storageSize` value (e.g., `storageSize: 5Gi`).

* **MongoDB Service Name:**

    ```yaml
    mongo:
      mongoServiceName: mongodb
    ```

    * **Explanation:** To change the name of the MongoDB service, modify the `mongoServiceName` value. This name must match the connection string used by your application (e.g., `mongodb://<mongoServiceName>`).

* **Application Image and Tag:**

    ```yaml
    image:
      repository: <your-docker-username>/devops-assignment
      pullPolicy: IfNotPresent
      tag: "latest"
    ```

    * **Explanation:** To use a different application image, change the `repository` value. To use a different tag, change the `tag` value. To change the image pull policy, modify the `pullPolicy` value. Remember to replace `<your-docker-username>` with your actual docker username.

* **Application Node Environment:**

    ```yaml
    env:
      NODE_ENV: production
    ```

    * **Explanation:** To change the Node.js environment, modify the `NODE_ENV` value (e.g., `NODE_ENV: development`).

* **Application Resources:**

    ```yaml
    resources:
      limits:
        memory: 1Gi
      requests:
        cpu: 50m
        memory: 256Mi
    ```

    * **Explanation:** To adjust resource limits and requests, modify the `limits.memory`, `requests.cpu`, and `requests.memory` values.

* **Application Service Type and Port:**

    ```yaml
    service:
      type: ClusterIP
      port: 8080
    ```

    * **Explanation:** To change the Kubernetes Service type (e.g., to `NodePort` or `LoadBalancer`), modify the `type` value. To change the port that the application exposes, modify the `port` value.


After making changes, upgrade the Helm release:

```bash
helm upgrade <release-name> ./k8s-chart
```

## Rolling Update and Service Connectivity

### Rolling Update

* **Application Deployment:**
    * The application deployment utilizes Kubernetes' default rolling update strategy.
    * This strategy ensures minimal downtime during updates by gradually replacing old Pods with new ones, maintaining application availability.
    * Kubernetes controls the pace of the update, ensuring a smooth transition without service interruption.
* **MongoDB Deployment:**
    * The MongoDB deployment, managed by a StatefulSet, also performs rolling updates.
    * StatefulSets ensure that updates are performed in a controlled, sequential manner, preserving data consistency.
    * Each MongoDB Pod is updated one at a time, preventing data corruption and ensuring a reliable database state.
* **Rationale:**
    * The default rolling update strategy is chosen for its simplicity and effectiveness in minimizing downtime.
    * It aligns with best practices for deploying microservices and stateful applications in Kubernetes.

### Service Connectivity

* **MongoDB Service:**
    * The MongoDB database is exposed as a Kubernetes Service, with the name defined in the `values.yaml` file (`mongo.mongoServiceName`, defaulting to `mongodb`).
    * This Service provides a stable network endpoint for the MongoDB StatefulSet, abstracting the underlying Pods.
    * The Service is of type `ClusterIP`, making it accessible within the Kubernetes cluster.
* **Application Connectivity:**
    * The application connects to the MongoDB database using the Service name as the hostname in the connection URL (e.g., `mongodb://mongodb`).
    * Kubernetes' internal DNS resolves the Service name to the appropriate IP address, ensuring reliable connection.
* **Environment Variable for Service Name:**
    * The MongoDB Service name is passed to the `k8s-test.js` script using an environment variable (`MONGO_SERVICE_NAME`).
    * This allows the test script to dynamically adapt to different MongoDB Service names, as defined in the `values.yaml` file.
    * This ensures that the application and tests always connect to the correct service, even if the service name is changed.

## Key Decisions

* **Helm Chart:**
    * Using a Helm chart simplifies the deployment and management of the application and MongoDB.
    * Helm provides templating capabilities, allowing for parameterized deployments and easy customization.
    * It also manages dependencies and simplifies versioning, making it easier to maintain and update the deployment.
* **StatefulSet for MongoDB:**
    * A StatefulSet is chosen for MongoDB to ensure data persistence and consistent network identities for MongoDB Pods.
    * StatefulSets provide stable hostnames and persistent volumes, which are essential for stateful applications like databases.
    * This ensures that data is preserved across Pod restarts and updates.
* **Jobs for Testing:**
    * Using a Kubernetes Job to run the `k8s-test.js` script ensures that the test runs once to completion and then terminates.
    * Jobs are ideal for one-time tasks like testing, as they automatically manage Pod lifecycles and completion.
    * This approach ensures that the test runs in a controlled environment and doesn't interfere with the running application.
* **Environment Variables:**
    * Environment variables are used to pass configuration data (like the MongoDB Service name) to the application and test scripts.
    * This decouples configuration from the application code, making it easier to manage and update.
    * It also allows for dynamic configuration based on the Kubernetes environment.
* **`values.yaml`:**
    * The `values.yaml` file serves as the single source of truth for all configuration values.
    * This centralizes configuration management, making it easier to customize and maintain the deployment.
    * It also allows for version control of configuration changes.