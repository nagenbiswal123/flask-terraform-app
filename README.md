# 🚀 Flask Application Deployment on AWS with Terraform

This project demonstrates deploying a simple **Flask web application** on an **AWS EC2 instance** using **Terraform**. It includes infrastructure provisioning (VPC, Subnet, Security Group, EC2), remote backend configuration (S3 & DynamoDB), and automated Flask app deployment using Terraform provisioners.

---

## 📂 Project Structure

```
.
├── app.py                # Flask application file
├── backend.tf            # Terraform backend configuration (S3 + DynamoDB)
├── main.tf               # Main infrastructure and provisioning
├── outputs.tf            # Outputs the EC2 public IP
└── README.md             # This documentation
```

---

## ⚙️ Prerequisites

Before you begin, make sure you have the following installed/configured:

- ✅ **AWS CLI** with valid credentials (`aws configure`)
- ✅ **Terraform** (v1.0 or higher) – [Install Terraform](https://developer.hashicorp.com/terraform/downloads)
- ✅ **S3 Bucket and DynamoDB table** already created for Terraform backend
- ✅ **SSH Key Pair** (e.g., `~/.ssh/id_rsa` and `~/.ssh/id_rsa.pub`) for EC2 access
- ✅ Permissions to manage EC2, VPC, S3, and DynamoDB resources

---

## 🧪 Installation and Setup

### 1. Clone the Repository

```bash
git clone https://github.com/nagenbiswal123/flask-terraform-app.git
cd flask-terraform-app
```

---

### 2. Update Configuration Files

Edit the following fields in your Terraform files before deploying:

#### In `backend.tf`:
- Replace `my-tf-test-bucket-20231005-123456` with your actual **S3 bucket** name.
- Replace `terraform-lock` with your actual **DynamoDB table** name.

#### In `main.tf`:
- Update `key_name` with your uploaded AWS **EC2 key pair**.
- Make sure the AMI (`ami-0f918f7e67a3323f0`) is **valid in `ap-south-1` (Mumbai)**.
- Confirm your **SSH key paths** (private: `~/.ssh/id_rsa`, public: `~/.ssh/id_rsa.pub`).

---

### 3. Initialize Terraform

Run the following command to initialize Terraform and configure the remote backend:

```bash
terraform init
```

---

## 🚀 Deploy the Infrastructure and Flask App

Run the following to deploy the infrastructure and start your Flask app:

```bash
terraform apply
```

Type `yes` when prompted.

Terraform will:

- ✅ Create a VPC, subnet, internet gateway, route table, and security group
- ✅ Launch an EC2 instance in `ap-south-1`
- ✅ Upload `app.py` to the instance
- ✅ Install Python and Flask via `remote-exec`
- ✅ Start the Flask app on **port 80**

---

## 🌐 Access the Application

Once deployed, Terraform will output the public IP of the EC2 instance.

Open your browser and go to:

```http
http://<your-ec2-public-ip>
```

You should see:

```
Hello, Terraform!
```

---

## 🧹 Clean Up

To destroy all AWS resources created by Terraform:

```bash
terraform destroy
```

Confirm with `yes` when prompted.

---

## ❗ Important Notes

- Ensure your **Security Group** allows:
  - Inbound **port 80** (HTTP)
  - Inbound **port 22** (SSH)
- Use `chmod 400 ~/.ssh/id_rsa` if SSH permission is denied.
- You can test SSH access using:

```bash
ssh -i ~/.ssh/id_rsa ubuntu@<your-ec2-public-ip>
```

---

## 📘 References

- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Terraform Provisioners](https://developer.hashicorp.com/terraform/language/resources/provisioners/syntax)
- [Flask Documentation](https://flask.palletsprojects.com/)

---

## 👨‍💻 Author

**Nagen Biswal**  
Cloud Engineer | DevOps | Terraform Infrstructure
