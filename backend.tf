# The following resources (S3 bucket and DynamoDB table) must be created before applying the Terraform configuration
# These resources are used for storing the Terraform state file and for state locking.


# Define an S3 bucket for storing the Terraform state file
# resource "aws_s3_bucket" "appbucket" {
#     bucket = "my-tf-test-bucket-20231005-123456"   # Unique name for the S3 bucket
    
#     tags = {
#       Name = "My Bucket"                           # Tag for the bucket indicating its purpose
#       Environment = "Development"                     # Tag indicating the environment (e.g., Development)
#     }
# }

# Define a DynamoDB table for state locking to prevent concurrent operations
# resource "aws_dynamodb_table" "terraform_lock" {
#   name           = "terraform-lock"             # Name of the DynamoDB table
#   billing_mode   = "PAY_PER_REQUEST"            # Use on-demand billing mode
#   hash_key       = "LockID"                     # Define the primary key for the table


# Define the attributes for the DynamoDB table
#   attribute {
#     name = "LockID"                             # Name of the attribute (primary key)
#     type = "S"                                  # Type of the attribute (S for String)
#   }
# }


# Configure the Terraform backend to use S3 for storing the state file
terraform {
  backend "s3" {
    bucket = "my-tf-test-bucket-20231005-123456"    # S3 bucket name for storing the state file
    region = "ap-south-1"                           # AWS region where the S3 bucket is located
    key = "biswal/terraform.tfstate"                # Path within the bucket to store the state file
    dynamodb_table = "terraform-lock"               # DynamoDB table name for state locking
  }
}