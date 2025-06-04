# CI/CD Pipeline for Flask App Deployment on AWS EKS using Jenkins, Terraform, and Docker

---

### **Overview**

This project automates the full lifecycle of deploying a Python Flask application to AWS Elastic Kubernetes Service (EKS) using Jenkins for CI/CD orchestration, Terraform for Infrastructure as Code (IaC), Docker for containerization, and Kubernetes for container orchestration.

---

### **Architecture Diagram**

```plaintext
+---------------------+      +--------------------+      +-------------------+
|     GitHub Repo     | ---> |     Jenkins CI     | ---> |     AWS ECR       |
+---------------------+      +--------------------+      +-------------------+
                                         |                      |
                                         v                      v
                                 +---------------+      +------------------+
                                 |   Terraform   | ---> |   AWS Resources  |
                                 +---------------+      |   (EKS, VPC, etc)|
                                                           +------------------+
                                                                |
                                                                v
                                                      +----------------------+
                                                      | Kubernetes (EKS)     |
                                                      | Flask App Deployed   |
                                                      +----------------------+
```

---

### **Tools & Services Used**

* **Jenkins**: Orchestrates CI/CD pipeline.
* **Terraform**: Provisions infrastructure (VPC, Subnets, ECR, EKS).
* **AWS Services**: EKS, VPC, ECR, IAM, NAT Gateway, Internet Gateway, Subnets.
* **Docker**: Containerizes the Flask application.
* **Kubernetes**: Deploys and manages the container.
* **GitHub**: Version control repository for Flask app and Terraform code.

---

### **Pipeline Stages (Detailed)**

1. **Checkout Source Code**

   * Jenkins fetches code from GitHub repository:

     ```
     https://github.com/ankitalodha05/-Deploy-a-Python-Flask-App-to-AWS-EKS-using-CI-CD
     ```

2. **Clean Workspace**

   * Uses `deleteDir()` in Jenkins to ensure a clean build environment.

3. **Terraform Initialization and Apply**

   * `terraform init` initializes Terraform providers and backends.
   * `terraform apply -auto-approve` provisions:

     * A VPC with 4 subnets (2 public, 2 private)
     * Route tables, NAT gateway, and Internet gateway
     * IAM roles for EKS cluster and nodes
     * ECR repository
     * EKS cluster with managed node group
     * Configures kubeconfig and aws-auth

4. **Fetch ECR URI**

   * Extracts output `ecr_repository_url` using:

     ```bash
     terraform output -raw ecr_repository_url
     ```

5. **Docker Image Build & Push**

   * Jenkins builds image using Dockerfile in `flaskapp/`.
   * Tags the image with the ECR repository URL.
   * Logs into ECR using AWS CLI and pushes the image.

6. **Deploy to EKS**

   * Copies `deployment-template.yaml` to `deployment.yaml`
   * Replaces placeholder with actual ECR image URI using `sed`
   * Deploys using `kubectl apply -f deployment.yaml` and `service.yaml`

7. **Post Actions**

   * Pipeline logs completion message on successful deployment.

---

### **Directory Structure**

```plaintext
Flask-App-to-AWS-EKS/
│
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── terraform.tfvars
│   ├── backend.tf
│   └── modules/
│       ├── vpc/
│       ├── ecr/
│       └── eks/
│
├── flaskapp/
│   ├── app.py
│   ├── Dockerfile
│   └── requirements.txt
│
├── deployment-template.yaml
├── service.yaml
└── Jenkinsfile
```

---

### **Key Configuration Details**

* **Cluster Name**: `my-flask-cluster`
* **Node Group Name**: `my-flask-cluster-nodegroup`
* **Docker Image Name**: `my-flask-repo:latest`
* **ECR URI**: `160885291806.dkr.ecr.ap-south-1.amazonaws.com/my-flask-repo`

---

### **Infrastructure Summary**

| Component     | Resource Type                | Details                                  |
| ------------- | ---------------------------- | ---------------------------------------- |
| VPC           | aws\_vpc                     | 10.0.0.0/16                              |
| Subnets       | aws\_subnet (public/private) | 2 public, 2 private                      |
| IGW           | aws\_internet\_gateway       | Enables internet access                  |
| NAT Gateway   | aws\_nat\_gateway            | Allows private subnet access to internet |
| IAM Roles     | aws\_iam\_role               | For EKS cluster and worker nodes         |
| EKS Cluster   | aws\_eks\_cluster            | Kubernetes control plane                 |
| EKS Nodegroup | aws\_eks\_node\_group        | Worker nodes using t2.micro instances    |
| ECR           | aws\_ecr\_repository         | Container registry                       |

---

### **Technologies Used**

* **CI/CD**: Jenkins
* **Infrastructure**: Terraform
* **Cloud**: AWS (EKS, IAM, VPC, ECR)
* **Containerization**: Docker
* **Application**: Flask (Python)
* **Orchestration**: Kubernetes (kubectl)

---

### **Benefits & Improvements**

* 🔄 **Fully automated** CI/CD for containerized applications
* 📦 **Reusable Terraform modules** for infrastructure provisioning
* 🚀 **Rapid deployment** and scaling with EKS
* ✅ **Standardized workflows** using Jenkins pipeline

---

### **Conclusion**

This project sets up a full DevOps pipeline to deploy a Python Flask application on Kubernetes using AWS EKS. Jenkins handles the CI/CD workflow, Terraform provisions cloud infrastructure, and Docker manages container builds. This system supports automation, scalability, and repeatability for cloud-native deployments.
