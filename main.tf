provider "aws" {
  region  = "us-east-1"
  profile = "lab"
}


module "rds" {
  source = "./rds"

  db_sg_id             = var.db_sg_id
  db_subnet_group_name = var.db_subnet_group_name

}

module "vpc" {
  source = "./vpc"

  vpc_id = var.vpc_id
}

module "alb" {
  source = "./alb"

  alb_sg_id         = var.alb_sg_id
  public_subnet_ids = var.public_subnet_ids
  vpc_id            = module.vpc.vpc_id

}



//module "ec2" {
//    source = "./ec2"
//    app_sg_id = var.app_sg_id
//}

