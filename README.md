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
* **MySQL Workbench**: Used to create and manage the application database.

---

### **MySQL Database Setup**

* A MySQL database instance was **created manually** via the AWS Console.
* Database and required tables were **configured using MySQL Workbench**.
* The **endpoint of this RDS database** was configured into:

  * The `app.py` file of the Flask application.
  * The `deployment.yaml` for Kubernetes so the pod can connect to the DB.

This setup allows the Flask application to persist and query data from the RDS database.

### **Jenkins Server Installation via User Data Script**

A Jenkins server was provisioned using the following user data script on an Ubuntu EC2 instance:

```bash
#!/bin/bash

sudo apt-get update -y
sudo apt-get install -y ca-certificates curl gnupg

sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo $VERSION_CODENAME) stable" \
  | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update -y
sudo apt install -y fontconfig openjdk-17-jre

sudo curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key \
  | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null

sudo echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" \
  | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

sudo apt-get update -y
sudo apt-get install -y jenkins

sudo systemctl start jenkins
sudo systemctl status jenkins
```

This script installs Docker, Java 17 (required by Jenkins), and Jenkins itself, and ensures that the Jenkins service starts on boot.

Additionally, an **IAM role with AdministratorAccess** was created and attached to the Jenkins EC2 instance. This allows Jenkins to execute AWS CLI and Terraform commands without additional access configuration.

---

### **Jenkins Docker and SSH Key Setup (Detailed)**

#### 1. **Grant Docker Access to Jenkins User**

```bash
sudo usermod -aG docker jenkins
```

#### 2. **Reload Jenkins User Session**

```bash
sudo su - jenkins
```

#### 3. **Test Docker Access**

```bash
docker ps
```

#### 4. **Generate SSH Key Pair for Jenkins User**

```bash
ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N ""
```

#### 5. **Set Proper SSH Permissions**

```bash
chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_rsa
chmod 644 ~/.ssh/id_rsa.pub
```

#### 6. **Verify Key Presence**

```bash
ls /var/lib/jenkins/.ssh
```

#### 7. **Use Case**

* This setup is used when Jenkins needs to SSH into remote servers (e.g., EC2, Git server, or other agents).

---

### **Jenkins Project Setup**

* After setting up the Jenkins server, logged into the Jenkins Dashboard.
* Created a new project named **`project1`**.
* Selected **Pipeline** project type.
* Configured the pipeline to use **Pipeline script from SCM**.
* Connected the pipeline to a GitHub repository containing the `Jenkinsfile` and project code.
* Triggered the initial build which executed the entire CI/CD pipeline.

---

###

---

### **CI/CD Pipeline Stages**

1. **Checkout Source Code**
2. **Clean Workspace**
3. **Terraform Init & Apply**
4. **Fetch ECR URI**
5. **Docker Build & Push**
6. **Deploy to EKS**

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
| RDS           | aws\_rds\_instance (manual)  | MySQL DB instance for app backend        |

---

### **Technologies Used**

* **CI/CD**: Jenkins
* **Infrastructure**: Terraform
* **Cloud**: AWS (EKS, IAM, VPC, ECR, RDS)
* **Containerization**: Docker
* **Application**: Flask (Python)
* **Orchestration**: Kubernetes (kubectl)
* **Database**: MySQL (configured via Workbench)

---

### **Benefits & Improvements**

* 🔄 **Fully automated** CI/CD for containerized applications
* 📦 **Reusable Terraform modules** for infrastructure provisioning
* 🚀 **Rapid deployment** and scaling with EKS
* ✅ **Standardized workflows** using Jenkins pipeline

---

### **Conclusion**

This project sets up a full DevOps pipeline to deploy a Python Flask application on Kubernetes using AWS EKS. Jenkins handles the CI/CD workflow, Terraform provisions cloud infrastructure, Docker manages container builds, and MySQL provides backend data storage. The system ensures secure, repeatable, and scalable deployments in a production-ready environment.
