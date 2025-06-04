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

### **Jenkins Docker and SSH Key Setup (Detailed)**

#### 1. **Grant Docker Access to Jenkins User**

```bash
sudo usermod -aG docker jenkins
```

* Adds `jenkins` user to the `docker` group so it can run Docker commands without `sudo`.

#### 2. **Reload Jenkins User Session**

```bash
sudo su - jenkins
```

* Re-login to apply group membership changes.

#### 3. **Test Docker Access**

```bash
docker ps
```

* Should not return a "permission denied" error.

#### 4. **Generate SSH Key Pair for Jenkins User**

```bash
ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N ""
```

* Creates a 4096-bit RSA key.
* No passphrase (`-N ""`) to allow automation.

#### 5. **Set Proper SSH Permissions**

```bash
chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_rsa
chmod 644 ~/.ssh/id_rsa.pub
```

* Correct file permissions to allow SSH to use these keys securely.

#### 6. **Verify Key Presence**

```bash
ls /var/lib/jenkins/.ssh
```

* You should see:

  * `id_rsa` (private key)
  * `id_rsa.pub` (public key)

#### 7. **Use Case**

* This setup is used when Jenkins needs to SSH into remote servers (e.g., EC2, Git server, or other agents).
* Common for GitOps, deployment, or remote execution steps.

---

### **CI/CD Pipeline Stages**

1. **Checkout Source Code**

   * Jenkins fetches code from GitHub repository:

     ```
     https://github.com/ankitalodha05/-Deploy-a-Python-Flask-App-to-AWS-EKS-using-CI-CD
     ```

2. **Clean Workspace**

   * Uses `deleteDir()` in Jenkins to ensure a clean build environment.

3. **Terraform Init & Apply**

   * Provisions full AWS infrastructure using IaC.

4. **Fetch ECR URI**

   * Uses Terraform output to retrieve ECR image repository.

5. **Docker Build & Push**

   * Jenkins builds Docker image for Flask app and pushes to ECR.

6. **Deploy to EKS**

   * Jenkins uses `kubectl` to deploy the application to the Kubernetes cluster.

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

This project sets up a full DevOps pipeline to deploy a Python Flask application on Kubernetes using AWS EKS. Jenkins handles the CI/CD workflow, Terraform provisions cloud infrastructure, and Docker manages container builds. The SSH and Docker permissions setup ensures secure and seamless build operations for Jenkins in a production-ready environment.
