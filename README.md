# Project Description
 ChatGPT Automate AWS infrastructure deployment with this Terraform project. Create a VPC, public subnet, and Docker-enabled EC2 instance. Easily customizable through variable definitions and well-organized file structure.

## Overview
This Terraform project automates the provisioning of infrastructure on AWS, creating a VPC (Virtual Private Cloud), a public subnet, and deploying a Docker-enabled EC2 instance.

## Files Structure
main.tf: Contains the main configuration for AWS resources, including VPC, subnet, internet gateway, route table, security group, key pair, and EC2 instance.
output.tf: Defines output variables that provide useful information after deployment.
datasource.tf: Includes data sources to fetch external information, such as the latest Amazon Machine Image (AMI) for the EC2 instance.
config.tpl: Template file for cloud-init user data script used during EC2 instance creation.
providers.tf: Specifies the provider configurations, in this case, AWS.
terraform.tfvars: Variable definitions for customizable values.
variables.tf: Declares input variables used throughout the Terraform configuration.
userdata.tpl: Template file for user data script that installs Docker on the EC2 instance.


## Usage
Clone the repository.
Customize terraform.tfvars with your specific values.
Run terraform init to initialize the working directory.
Run terraform apply to create the infrastructure.
After deployment, review the outputs in output.tf for relevant information.
## Notes
Ensure you have AWS credentials configured properly.
Customize security group rules, instance type, and other parameters as needed.
Refer to individual files for detailed comments and explanations.


Feel free to contribute or open issues for improvements and bug fixes!
