variable "region" {
  description = "AWS Region"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR for the VPC"
  type        = string
}

variable "public_subnet_cidr" {
  description = "CIDR for the public subnet"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "my_ip" {
  description = "Your public IP for SSH access (CIDR format)"
  type        = string
}

variable "key_name" {
  description = "Name of an existing EC2 key pair"
  type        = string
  default     = null
}

variable "s3_bucket_name" {
  description = "Name of the S3 bucket for Terraform state"
  type        = string
}

variable "dynamodb_table_name" {
  description = "Name of the DynamoDB table for state locking"
  type        = string
}

variable "instance_name" {
  description = "Value of the Name tag for the EC2 instance"
  type        = string
}
