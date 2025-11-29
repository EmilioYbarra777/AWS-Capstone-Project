output "rds_endpoint" {
  value = module.rds.db_endpoint
}


output "alb_dns_name" {
  value       = module.alb.alb_dns_name
  description = "DNS name to access the web application"
}

output "target_group_arn" {
  value       = module.alb.target_group_arn
  description = "Target group ARN for attaching EC2 instances"
}


output "asg_name" {
  value = module.asg.asg_name
  description = "Name of the Auto Scaling Group"
}