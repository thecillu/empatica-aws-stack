# variables.tf

variable "aws_region" {
  description = "The AWS region things are created in"
  default     = "eu-central-1"
}

variable "ecs_task_execution_role_name" {
  description = "ECS task execution role name"
  default = "myEcsTaskExecutionRole"
}

variable "az_count" {
  description = "Number of AZs to cover in a given region"
  default     = "2"
}

variable "cidr_block" {
  description = "CIDR block of the VPC"
  default     = "172.17.0.0/16"
}


variable "image_version" {
  description = "Docker image version (tag, branch or commit) to run in the ECS cluster"
  default = "0.0.5"
}

variable "app_port" {
  description = "Port exposed by the docker image to redirect traffic to"
  default     = 80
}

variable "lb_port" {
  description = "Port exposed by the docker image to redirect traffic to"
  default     = 80
}

variable "app_count" {
  description = "Number of docker containers to run"
  default     = 1
}

variable "health_check_path" {
  default = "/"
}

variable "fargate_cpu" {
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
  default     = "1024"
}

variable "fargate_memory" {
  description = "Fargate instance memory to provision (in MiB)"
  default     = "2048"
}

variable "database_name" {
  description = "The database name"
  default = "empatica" 
}

variable "database_username" {
  description = "The database master username"
  default = "root" 
}

variable "database_password" {
  description = "The database master password"
  default = "EmpaticaPwd1" 
}


