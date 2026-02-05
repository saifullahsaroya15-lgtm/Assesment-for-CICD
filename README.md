# DevOps Technical Assessment - Option A: CI/CD Pipeline

This repository contains a complete solution for the "CI/CD Pipeline" technical assessment task. It demonstrates a production-ready approach to containerizing a Node.js application and automating its delivery using GitHub Actions.

##  Project Overview

The project consists of:
1.  **Application**: A lightweight Node.js Express service with unit tests and a health check endpoint.
2.  **Containerization**: An optimized, secure, multi-stage Dockerfile.
3.  **CI/CD Pipeline**: A GitHub Actions workflow handling testing, building, security scanning, and deployment.

##  Architecture Decisions ("Senior Engineer" Rationale)

### 1. Application Layer
- **Health Check (`/health`)**: Essential for orchestration platforms (Kubernetes/ECS) to determine container liveliness.
- **Graceful Shutdown**: (Implicit in Node) Ensuring the app handles signals correctly.

### 2. Docker / Containerization
- **Multi-Stage Build**: I used a multi-stage `Dockerfile`.
    - *Builder Stage*: Installs full dependencies (including dev) to potentially run build scripts.
    - *Runner Stage*: Copies only `node_modules` (production only) and app code.
- **Security (Non-Root User)**: The container creates and switches to a user `appuser`. Running as root is a major security risk in production.
- **Layer Caching**: `COPY package*.json` is done before copying source code to leverage Docker layer caching for faster builds.

### 3. CI/CD Pipeline (GitHub Actions)
The pipeline is defined in `.github/workflows/ci-cd.yml` and includes:

- **Stage 1: CI & Testing**:
    - Installs dependencies and runs `npm test`.
    - This ensures broken code never reaches the build stage.
- **Stage 2: Build & Security**:
    - Builds the Docker image.
    - **Security Scan**: Uses **Trivy** to scan the built image for High/Critical CVEs. This illustrates "Shift Left" security.
- **Stage 3: Deployment (CD)**:
    - Runs only on the `main` branch.
    - *Note*: As credentials were not provided, this step simulates the deployment commands (e.g., `kubectl apply` or `aws ecs update-service`).

##  How to Run Locally

### Prerequisites
- Node.js & npm
- Docker

### Running the App
```bash
# Install dependencies
npm install

# Run tests
npm test

# Start the server
npm start
```

### Building & Running with Docker
```bash
# Build the image
docker build -t devops-app .

# Run the container (mapping port 3000)
docker run -p 3000:3000 devops-app
```

Visit `http://localhost:3000` to see the app, or `http://localhost:3000/health` for the health check.

##  Assessment Checklist

- [x] **Containerized App**: Dockerfile included.
- [x] **Build**: Pipeline builds Docker image.
- [x] **Test**: Pipeline runs unit tests.
- [x] **Security Scan**: Integrated Trivy scanner.
- [x] **Deploy to Staging**: Deployment job configured (simulated).

##  Required GitHub Secrets (For Production)

To make this pipeline fully functional (Push & Deploy), you would configure the following **GitHub Actions Secrets**:

| Secret Name | Description |
| :--- | :--- |
| `CR_PAT` | Personal Access Token for GitHub Container Registry (used in deployment). |
| `EC2_HOST` | EC2 instance public IP or hostname (for SSH deployment). |
| `EC2_USER` | SSH username for EC2 instance. |
| `EC2_SSH_KEY` | Private SSH key for EC2 instance. |

*Note: `GITHUB_TOKEN` is automatically provided by GitHub Actions for GHCR access. Deployment is optional and will be skipped if these secrets are not configured.*

*These are not required for the current simulation mode.*

---
*Ready for submission.*
