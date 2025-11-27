resource "aws_secretsmanager_secret" "db_credentials" {
  name = "rds-mysql-credentials"
}

resource "random_password" "db_password" {
  length  = 16
  special = false
}

resource "aws_secretsmanager_secret_version" "db_credentials_value" {
  secret_id     = aws_secretsmanager_secret.db_credentials.id

  secret_string = jsonencode({
    username = "admin"
    password = random_password.db_password.result
  })

  lifecycle {
    ignore_changes = [secret_string]  # <-- Prevent password from regenerating when reapplying terraform
  }
}
