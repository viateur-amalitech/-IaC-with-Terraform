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

### 1. Setup Configuration Files
Since sensitive configuration files are not tracked in Git, you must create them from the provided templates:
```bash
cp terraform.tfvars.example terraform.tfvars
cp backend.hcl.example backend.hcl
```
Open both files and update the values with your specific AWS details (Region, Bucket Name, Key Name, etc.).

### 2. Initial Deployment (Local State)
Ensure the `backend "s3"` block in `backend.tf` is **commented out** for the first run. 
Initialize and deploy the infrastructure locally to create the foundational resources:
```bash
terraform init
terraform apply -auto-approve
```
This step creates the VPC and EC2, as well as the **S3 Bucket** and **DynamoDB Table** required for the remote backend.

### 3. Migrate to Remote Backend
Once the S3 bucket exists:
1.  **Uncomment** the `backend "s3" {}` block in `backend.tf`.
2.  Initialize the backend migration:
    ```bash
    terraform init -backend-config=backend.hcl -migrate-state
    ```
3.  Type **`yes`** when prompted to copy the local state to S3.

### 4. Verification
*   **Web Server**: Run `curl http://$(terraform output -raw instance_public_ip)` to see the Nginx welcome message.
*   **Remote State**: Verify the `terraform.tfstate` file exists in your S3 bucket via the AWS Console.
*   **Locking**: Verify the DynamoDB table `terraform-state-locks` is created for state locking.

### 5. Cleanup
To destroy all provisioned resources:
```bash
# Update backend.tf by commenting out the s3 block and running init -reconfigure first if S3 is deleted
terraform destroy -auto-approve
```
