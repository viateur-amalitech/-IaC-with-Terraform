# Project: Infrastructure as Code with Terraform

This project demonstrates how to define and deploy foundational AWS infrastructure using Terraform. It specifically covers the setup of a VPC, networking components, and an EC2 instance, followed by a migration to a remote backend (S3 + DynamoDB) for state management and locking.

## Objectives
*   Define foundational AWS resources using Terraform.
*   Implement a remote backend with S3 and DynamoDB locking.
*   Utilize `terraform.tfvars` for clean variable management.

## Project Structure
*   `main.tf`: Contains resource definitions (VPC, IGW, Subnet, Route Table, SG, EC2, S3, DynamoDB).
*   `variables.tf`: Variable declarations and types.
*   `terraform.tfvars`: Input values for the variables (Environment-specific setup).
*   `outputs.tf`: Important resource information (Public IPs, IDs).
*   `backend.tf`: Configuration for the S3 remote backend.

## Prerequisites
1.  **Terraform v1.5+** installed.
2.  **AWS CLI** configured with appropriate credentials.

---

## Step-by-Step Deployment Instructions

### 1. Configure Variable Values
Open `terraform.tfvars` and provide your specific values:
*   `region`: Your chosen AWS Region (e.g., `eu-north-1`).
*   `s3_bucket_name`: MUST BE GLOBALLY UNIQUE (e.g., `viateur-yourname-tfstate-lab-01`).
*   `my_ip`: Your public IP for SSH access (use `0.0.0.0/0` for open access or your specific IP).

### 2. Initial Deployment (Local State)
Check that the `backend "s3"` block in `backend.tf` is **commented out**. 

Initialize and deploy the infrastructure locally first:
```bash
terraform init
terraform plan
terraform apply
```
*Type `yes` when prompted.*

This creates the VPC and EC2, as well as the **S3 Bucket** and **DynamoDB Table** that will soon hold your state.

### 3. Migrate to Remote Backend (Partial Configuration)
Once the resources are created:
1.  Open `backend.tf` and **uncomment** the `terraform` block.
2.  Run the initialization by passing the configuration file:
    ```bash
    terraform init -backend-config=backend.hcl
    ```
3.  Terraform will ask: *"Do you want to copy existing state to the new backend?"*
    Type **`yes`**.

### 4. Verification
*   **AWS Console**: Verify the EC2 instance is running and the VPC is created.
*   **S3**: Check your bucket for the `terraform.tfstate` file.
*   **Nginx Test**: Run `curl http://<INSTANCE_PUBLIC_IP>` to see the Nginx welcome message.
*   **SSH Test**: If you provided an existing key pair, you can SSH into the instance using:
    ```bash
    ssh -i viateur.pem ec2-user@<INSTANCE_PUBLIC_IP>
    ```

### 5. Cleanup
To delete all resources and the backend state:
```bash
terraform destroy
```
