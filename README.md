## Step 4: Database Import Process

1. Retrieve RDS endpoint:
```bash
   terraform output rds_endpoint
```

2. SSH into one of the EC2 instances from the Auto Scaling Group

3. Get database credentials:
```bash
   aws secretsmanager get-secret-value \
     --secret-id rds-mysql-credentials \
     --region us-east-1
```

4. Import the SQL dump:
```bash
   mysql -h <RDS_ENDPOINT> -u admin -p countries < /path/to/Countries.sql
```