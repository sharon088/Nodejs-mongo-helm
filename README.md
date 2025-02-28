# DevOps Assignment - Docker, Kubernetes, and Helm

This README provides detailed instructions on how to build and deploy the application and MongoDB using Docker, Kubernetes, and Helm. It explains how to customize deployment parameters and describes the rolling update and service connectivity setup.

---

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Building the Docker Container](#building-the-docker-container)
3. [Deploying the Application and MongoDB using Helm](#deploying-the-application-and-mongodb-using-helm)
4. [Customizing Deployment Parameters](#customizing-deployment-parameters)
5. [Rolling Updates and Service Connectivity](#rolling-updates-and-service-connectivity)
6. [Key Decisions and Implementation Explanation](#key-decisions-and-implementation-explanation)

---

## Prerequisites

Before you start, make sure the following software is installed:

- **Docker** – for building and running containers
- **Minikube**, **kind**, or another local Kubernetes distribution – for the Kubernetes cluster
- **kubectl** – command-line tool to interact with Kubernetes clusters
- **Helm** – for packaging and deploying Kubernetes applications using Helm charts

Additionally, ensure you have admin/root privileges to install necessary tools and an active internet connection.

---

## Building the Docker Container

### Step 1: Clone the Repository

Clone the repository containing the application files, including the Dockerfile, Node.js application, and other resources:

```bash
git clone <repository-url>
cd <repository-directory>
```

### Step 2: Dockerfile Overview

The Dockerfile uses a **multi-stage build** approach, which is divided into two stages:

1. **Build Stage**:
    - The base image is `node:23-alpine`.
    - It first sets the working directory to `/app` and copies the `package.json` to install the application dependencies.
    - The `npm install` command installs all the dependencies.
    - Next, it copies the source code (`src`) and the `start.sh` script into the container.

2. **Final Stage**:
    - The base image is again `node:23-alpine`, but this time it installs additional required packages such as `ca-certificates`, `bash`, `vim`, `procps`, and `curl`.
    - A new non-root user `appuser` is created with a custom user ID (`1500`) to improve security by avoiding running the application as root.
    - The application files from the build stage are copied into the final image.
    - The `start.sh` script is set to be executable and its ownership is assigned to `appuser`.
    - The final image is configured to run the application using the `/app/start.sh` script when the container starts.

This multi-stage build reduces the size of the final image by separating the build process from the runtime environment.

### Step 3: Build the Docker Image

To build the Docker container, run the following command:

```bash
docker build -t devops-assignment:latest .

