# Empatica AWS Stack

This project uses Terraform to create the AWS resources for the Empatica Challenge 1.

In details, the Terraform configuration:

1. Create a VPC
2. Create the public subnets and the related Internet Gateway and Routing Tables
3. Create the public subnets and the related NAT Gateways and Routing Tables
4. Create and ECS Cluster (Fargate) which host the RESTFul server Docker Image and deploy it in the private subnets
5. Configure the Autoscaling policies for the ECS Cluster
6. Create an Application Load Balancer which Listen on port 80 and forward the request to the ECS Target Groups
7. Create a Mysql RDS Instance and a defult database
8. Create the neeed Security Groups for the flow ALB --> ECS and ECS --> RDS


## AWS Credentials

The Terraform configuration reads the credentials file from the file: 

`$HOME/.aws/credentials`

Make sure to put in this file the credentials `aws_access_key_id` and `aws_secret_access_key` of a valid AWS User.

## AWS Region

The Terraform configuration uses the variable `aws_region` to indentify the target AWS Region.

By Default the deployment Region is `eu-central-1`.

## Create the AWS Stack

Clone the project, change dir to subfolder `terraform` and run the command:

`terraform apply`

When completed, Terraform will provide in output the created ALB address:

`alb_hostname = empatica-load-balancer-1789365880.eu-central-1.elb.amazonaws.com`


