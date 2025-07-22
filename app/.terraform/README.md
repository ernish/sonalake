## Prerequisites
* Terraform v1.x
* AWS CLI configured
* Access to the module sources
* providers
  * aws
  * random

## **Description**
Terraform configuration provisions cloud infrastructure including a VPC and an ECS-based application stack using modular, reusable components. It supports configurable environments, subnet setupsfor scalable infrastructure management.

## Usage
* Terraform init
* Terraform plan/apply

## Improvments:
* Add HTTPS listener fro ALB
* Seperate IAM role for ECS taskrole
* Add AutoScaling for ECS
* Add Secrets (ParameterStore) for ECS to inject sensitive data to container
* Attach ALB to WAF
* Use centralized AWS account for networking (use transit gateways)
* Create ECR repo and store there images (for this demo I used nginx image)
* Terraforms projects should be accessible localy but only for `terraform plan`
* Modules and stack-moudles shoudl be stored in seperate github repo with ref
* More outputs and variables
* ``terraform.tfstate`` can be injected during CI/CD
* Add Pre-commits (checkov, tfsec, tflint, infracost)
* Change naming convention 
* Add more variables for example for ports and Ips
* restrict access for security group, now is opened 
* Use ACL if needed 
* Use one NATGW for cost optimalization for non-prod
* Enable service discovery for ECS service
* Use Route53
* more description for variables
* Add variable validation
* Store tfstate in safety place for example S3 bucket on seperate AWS account with policy
* Enable vpc flow logs 
