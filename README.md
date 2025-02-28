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
