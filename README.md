# CI/CD Pipeline for Flask App Deployment on AWS EKS using Jenkins, Terraform, and Docker

---

### **Overview**

This project automates the deployment of a Python Flask application to an Amazon EKS (Elastic Kubernetes Service) cluster using Jenkins for CI/CD, Terraform for infrastructure provisioning, and Docker for containerization.

---

### **Components**

* **Jenkins**: Used for automating the build, deploy, and infrastructure steps.
* **Terraform**: Infrastructure as Code (IaC) tool used to provision AWS resources such as VPC, Subnets, ECR, IAM, and EKS.
* **AWS Services**:

  * VPC (with public/private subnets, NAT, IGW)
  * ECR (Elastic Container Registry)
  * EKS (Elastic Kubernetes Service)
  * IAM Roles and Policies
* **Docker**: To containerize the Flask application.
* **Kubernetes**: For container orchestration and deployment.

---

### **Pipeline Stages**

1. **Checkout Source Code**

   * Jenkins checks out the code from the GitHub repository:

     ```
     https://github.com/ankitalodha05/-Deploy-a-Python-Flask-App-to-AWS-EKS-using-CI-CD

     ```

2. **Clean Workspace**

   * Cleans Jenkins workspace using `deleteDir()`.

3. **Terraform Init & Apply**

   * Initializes Terraform and applies all configuration files to:

     * Provision VPC, Subnets, Internet Gateway, NAT Gateway, Route Tables
     * Create IAM Roles for EKS cluster and node group
     * Deploy EKS cluster and node group
     * Create ECR repository
     * Configure `aws-auth` and `kubeconfig`

4. **Fetch ECR URI**

   * Extracts ECR URI using `terraform output` and stores it in a variable.

5. **Docker Build & Push**

   * Builds the Docker image from Flask source
   * Tags it with the ECR URI
   * Logs into ECR and pushes the image to the repository

6. **Deploy to EKS**

   * Updates kubeconfig for the EKS cluster
   * Uses `kubectl` to apply Kubernetes deployment and service manifests
   * Updates the deployment.yaml file with the actual ECR image URI

7. **Post Actions**

   * Logs the pipeline success message

---

### **Folder Structure**

```
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

### **Key Outputs**

* **ECR Repository URL**: `160885291806.dkr.ecr.ap-south-1.amazonaws.com/my-flask-repo`
* **EKS Cluster Name**: `my-flask-cluster`
* **Node Group Name**: `my-flask-cluster-nodegroup`
* **Docker Image**: `my-flask-repo:latest`

---

### **Technologies Used**

* **AWS**: EKS, ECR, IAM, VPC
* **Jenkins**: Automation and CI/CD
* **Terraform**: Infrastructure as Code
* **Docker**: Containerization
* **Python (Flask)**: Backend web application
* **Kubernetes**: Deployment orchestration

---

### **Conclusion**

This project demonstrates an end-to-end DevOps workflow for deploying a containerized Flask application to AWS using modern tools and infrastructure-as-code practices. The pipeline is designed to be scalable and reusable for future applications.

---

###
