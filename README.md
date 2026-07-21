# 🚀 Docker Image Information Dashboard — CI/CD with AWS ECR & Kubernetes

A DevOps project demonstrating an **end-to-end CI/CD pipeline** using GitHub Actions, Docker, AWS ECR, Kubernetes, and an AWS EC2 self-hosted runner.

Whenever code is pushed to the `main` branch, the pipeline automatically:

- Tests the Flask application
- Generates build and version metadata
- Builds a Docker image
- Pushes the image to AWS ECR
- Updates the Kubernetes deployment
- Performs a rolling deployment of the new application version

---

## 📌 Project Overview

The **Docker Image Information Dashboard** is a Flask-based web application that displays information about the currently deployed application and container image.

The dashboard displays:

- Application name
- Application version
- CI/CD build number
- Docker image tag
- Git commit SHA
- Deployment time
- Environment
- Kubernetes pod hostname
- Application health status

This makes it easy to identify **exactly which version of the application is currently running**.

---

## 🏗️ Architecture

```text
Developer
    │
    │ git push
    ▼
GitHub Repository
    │
    ▼
GitHub Actions
    │
    ▼
Self-Hosted Runner on AWS EC2
    │
    ├── Run Pytest Tests
    │
    ├── Generate Build Metadata
    │
    └── Build Docker Image
    │
    ▼
AWS ECR
Private Container Registry
    │
    ▼
Kubernetes / Minikube
    │
    ├── Authenticate to Private ECR
    ├── Pull New Docker Image
    └── Perform Rolling Update
    │
    ▼
Flask + Gunicorn Application
    │
    ▼
Status: Healthy ✅
```

---

## 🛠️ Tech Stack

| Category | Technology |
|---|---|
| Application | Python, Flask |
| Application Server | Gunicorn |
| Testing | Pytest |
| Version Control | Git, GitHub |
| CI/CD | GitHub Actions |
| CI/CD Runner | AWS EC2 Self-Hosted Runner |
| Containerization | Docker |
| Container Registry | AWS ECR |
| Cloud | AWS EC2, IAM, ECR |
| Container Orchestration | Kubernetes |
| Local Kubernetes Cluster | Minikube |

---

## 📂 Project Structure

```text
docker-image-dashboard/
│
├── .github/
│   └── workflows/
│       └── deploy.yml
│
├── k8s/
│   ├── deployment.yaml
│   └── service.yaml
│
├── templates/
│   └── index.html
│
├── tests/
│   └── test_app.py
│
├── app.py
├── Dockerfile
├── requirements.txt
├── .dockerignore
├── .gitignore
└── README.md
```

---

## ✨ Application Features

### Deployment Information Dashboard

The application dynamically displays information about the currently deployed build.

Example:

```text
Application Name : Docker Image Information Dashboard
App Version      : 1.0.10
Build Number     : 10
Docker Image Tag : 8481176
Environment      : Production
Status           : Healthy
```

### API Endpoints

| Endpoint | Description |
|---|---|
| `/` | Displays the web dashboard |
| `/info` | Returns deployment and build metadata as JSON |
| `/health` | Application health-check endpoint |

Example `/info` response:

```json
{
  "app_name": "Docker Image Information Dashboard",
  "app_version": "1.0.10",
  "build_number": "10",
  "environment": "Production",
  "git_commit": "8481176e93715273570cfdf7b2b7b0b5a1f1ef23",
  "image_tag": "8481176",
  "status": "Healthy"
}
```

---

# 🔄 CI/CD Pipeline

The CI/CD workflow is defined in:

```text
.github/workflows/deploy.yml
```

A push to the `main` branch automatically triggers the pipeline.

```text
Git Push
    │
    ▼
Checkout Source Code
    │
    ▼
Set Up Python
    │
    ▼
Install Dependencies
    │
    ▼
Run Automated Tests
    │
    ▼
Generate Build Metadata
    │
    ▼
Authenticate to AWS ECR
    │
    ▼
Build Docker Image
    │
    ▼
Push Image to AWS ECR
    │
    ▼
Update Kubernetes Deployment
    │
    ▼
Kubernetes Rolling Update
    │
    ▼
Application Running ✅
```

---

## 🧪 Automated Testing

The project uses **Pytest** to validate the Flask application before deployment.

Tests are located in:

```text
tests/test_app.py
```

Run tests locally:

```bash
python3 -m pytest tests/ -v
```

The tests verify important application endpoints such as:

```text
/
    
/health
```

### CI/CD Quality Gate

```text
Tests Pass
    │
    ▼
Build & Deploy

Tests Fail
    │
    ▼
Pipeline Stops ❌
```

This prevents failed application code from continuing through the deployment pipeline.

---

## 🐳 Docker Containerization

The Flask application is containerized using Docker.

The image contains:

```text
Python Runtime
      +
Flask Application
      +
Dependencies
      +
Gunicorn
      +
CI/CD Build Metadata
```

The pipeline injects build information into every Docker image:

```text
APP_VERSION
BUILD_NUMBER
IMAGE_TAG
GIT_COMMIT
```

This allows each deployed container to identify exactly which CI/CD build and Git commit created it.

---

## 📦 AWS ECR

AWS Elastic Container Registry is used as the project's **private Docker image registry**.

The pipeline automatically performs:

```text
Docker Build
      │
      ▼
Generate Unique Image Tag
      │
      ▼
Authenticate to AWS ECR
      │
      ▼
Push Docker Image
      │
      ▼
AWS ECR Repository
```

Images are tagged using Git commit information, making application versions traceable.

Example:

```text
docker-image-dashboard:8481176
```

### Why AWS ECR?

ECR provides:

- Private Docker image storage
- AWS IAM integration
- Secure authentication
- Image version management
- Integration with container deployment platforms

---

## ☁️ AWS EC2 Self-Hosted Runner

An AWS EC2 instance is configured as a **GitHub Actions self-hosted runner**.

The runner executes the CI/CD jobs sent by GitHub Actions.

It performs operations such as:

```text
pytest
docker build
docker push
AWS ECR authentication
kubectl deployment commands
```

Architecture:

```text
GitHub Actions
      │
      ▼
EC2 Self-Hosted Runner
      │
      ├── Docker
      ├── AWS CLI
      └── kubectl
```

An IAM role is attached to EC2 to provide the required AWS permissions without storing permanent AWS credentials directly in the source code.

---

## ☸️ Kubernetes Deployment

The application is deployed to a **Minikube Kubernetes cluster running on AWS EC2**.

Kubernetes configuration:

```text
k8s/
├── deployment.yaml
└── service.yaml
```

### Deployment

The Kubernetes Deployment manages:

- Application pods
- Docker image versions
- Container environment variables
- Rolling updates

Check deployment:

```bash
kubectl get deployment
```

Check pods:

```bash
kubectl get pods
```

Expected result:

```text
NAME                                READY   STATUS
docker-dashboard-xxxxxxxxxx-xxxxx   1/1     Running
```

---

## 🔐 Private ECR Authentication

Because the ECR repository is private, Kubernetes requires authentication before pulling images.

A Kubernetes registry secret is configured:

```text
ecr-secret
```

The deployment references the secret:

```yaml
imagePullSecrets:
  - name: ecr-secret
```

The flow becomes:

```text
Kubernetes
     │
     ▼
ECR Authentication
     │
     ▼
Private AWS ECR
     │
     ▼
Pull Docker Image
     │
     ▼
Start New Pod
```

> **Note:** ECR authorization tokens are temporary. A production environment should automate credential rotation or use an AWS-integrated Kubernetes authentication mechanism.

---

## 🔄 Kubernetes Rolling Updates

When a new application version is deployed, Kubernetes performs a rolling update.

```text
Old Pod Running
       │
       ├──────────────┐
       │              ▼
       │        New Pod Created
       │              │
       │              ▼
       │        New Pod Healthy
       │              │
       ▼              ▼
Old Pod Terminated   New Pod Running
```

This allows Kubernetes to safely replace an older application version with the latest deployment.

---

# 🚀 Running the Project Locally

### 1. Clone the repository

```bash
git clone <your-repository-url>
cd docker-image-dashboard
```

### 2. Create a virtual environment

```bash
python3 -m venv venv
source venv/bin/activate
```

### 3. Install dependencies

```bash
pip install -r requirements.txt
```

### 4. Run tests

```bash
python3 -m pytest tests/ -v
```

### 5. Start the Flask application

```bash
python app.py
```

Access:

```text
http://localhost:5000
```

Health check:

```bash
curl http://127.0.0.1:5000/health
```

Application information:

```bash
curl http://127.0.0.1:5000/info
```

---

# 🐳 Running with Docker

Build the image:

```bash
docker build -t docker-image-dashboard:local .
```

Run the container:

```bash
docker run -d \
  --name docker-dashboard \
  -p 5000:5000 \
  docker-image-dashboard:local
```

Test:

```bash
curl http://127.0.0.1:5000/health
```

---

# ☸️ Kubernetes Commands

Check cluster:

```bash
kubectl get nodes
```

Check deployments:

```bash
kubectl get deployments
```

Check pods:

```bash
kubectl get pods
```

Check services:

```bash
kubectl get svc
```

Check deployment image:

```bash
kubectl get deployment docker-dashboard \
-o jsonpath='{.spec.template.spec.containers[0].image}'; echo
```

Check rollout:

```bash
kubectl rollout status deployment/docker-dashboard
```

---

## 🌐 Accessing the Application in Minikube

For testing the Kubernetes application:

```bash
kubectl port-forward \
service/docker-dashboard-service \
5001:5000 \
--address=0.0.0.0
```

Test internally:

```bash
curl http://127.0.0.1:5001/info
```

---

# 🧩 Challenges Solved

During implementation, several real DevOps issues were identified and resolved.

### Pytest Configuration

Resolved test discovery and Python import issues in the GitHub Actions environment.

### GitHub Actions Self-Hosted Runner

Configured an EC2 instance to receive and execute GitHub Actions CI/CD jobs.

### Docker Image Versioning

Implemented CI-generated:

```text
Application Version
Build Number
Image Tag
Git Commit SHA
```

### AWS ECR Integration

Migrated container image storage from Docker Hub to a private AWS ECR repository.

### IAM Permissions

Configured an EC2 IAM role for secure AWS ECR access.

### Kubernetes `ImagePullBackOff`

Resolved private ECR image authentication issues using Kubernetes `imagePullSecrets`.

### Kubernetes Networking

Troubleshot Minikube NodePort networking and used port forwarding for application verification.

### Rolling Deployment

Successfully replaced the old Docker Hub-based deployment with a new AWS ECR-based application image.

---

# 📚 Key DevOps Concepts Demonstrated

- Continuous Integration
- Continuous Deployment
- Git-based development workflow
- Automated testing
- CI quality gates
- Docker containerization
- Container image versioning
- Private container registries
- AWS IAM authentication
- AWS ECR
- GitHub Actions
- Self-hosted CI/CD runners
- Kubernetes Deployments
- Kubernetes Services
- Kubernetes Secrets
- Rolling updates
- Application health checks
- Deployment traceability

---

# 🎯 Final Result

The project implements an automated deployment workflow:

```text
Developer
    │
    ▼
GitHub
    │
    ▼
GitHub Actions
    │
    ▼
Automated Testing
    │
    ▼
Docker Build
    │
    ▼
AWS ECR
    │
    ▼
Kubernetes
    │
    ▼
Flask Application
    │
    ▼
HEALTHY ✅
```

A code push to the `main` branch automatically triggers the CI/CD pipeline, validates the application, creates a versioned Docker image, stores it in AWS ECR, and deploys the latest application version to Kubernetes.

---

## 👩‍💻 Author

**Fatimah Qureshi**

Computer Engineering Graduate | DevOps & Cloud Enthusiast

---

⭐ If you found this project useful, consider giving the repository a star!
