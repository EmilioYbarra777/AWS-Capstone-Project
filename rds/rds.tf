data "aws_secretsmanager_secret_version" "creds" {
  secret_id = aws_secretsmanager_secret.db_credentials.id

  depends_on = [
    aws_secretsmanager_secret_version.db_credentials_value
  ]
}

locals {
  db_user = jsondecode(data.aws_secretsmanager_secret_version.creds.secret_string)["username"]
  db_pass = jsondecode(data.aws_secretsmanager_secret_version.creds.secret_string)["password"]
}

resource "aws_db_instance" "mysql" {
  identifier              = "capstone-rds"
  engine                  = "mysql"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  username                = local.db_user
  password                = local.db_pass
  db_name                 = "countries"
  skip_final_snapshot     = true

  vpc_security_group_ids  = [var.db_sg_id]
  db_subnet_group_name    = var.db_subnet_group_name

  publicly_accessible     = false
}

