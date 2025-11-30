variable "db_sg_id" {
  type = string
}

variable "db_subnet_group_name" {
  type = string
}

variable "vpc_id" {
  type        = string
  description = "VPC ID for all resources"
}

variable "alb_sg_id" {
  type        = string
  description = "Security group ID for the Application Load Balancer"
}


variable "public_subnet_ids" {
  type        = list(string)
  description = "List of public subnet IDs for the ALB"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "List of private subnet IDs for the ASG"
}