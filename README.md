# AWS Cloud Architecting Capstone Project

## Overview

This project demonstrates the design and implementation of a highly available, secure, and scalable PHP web application infrastructure on AWS. The solution leverages multiple AWS services to create a production-ready architecture that follows cloud best practices for security, availability, and operational excellence.

## Objective

Build a secure, highly available PHP application infrastructure that:

- Hosts a MySQL database with secure credential management
- Distributes application load across multiple web servers and Availability Zones
- Utilizes AWS Secrets Manager for database credential storage and retrieval
- Imports existing data into the RDS MySQL database
- Prevents direct public access to application servers and backend systems
- Provides automatic scaling based on application demand

## Solution Requirements

### Core Infrastructure Requirements

✅ **Secure MySQL Database Hosting**
- RDS MySQL instance in private subnets
- Database credentials stored in AWS Secrets Manager
- Security groups restricting access to application servers only

✅ **Secure Database Access**
- PHP application retrieves credentials from Secrets Manager at runtime
- No hardcoded credentials in application code
- Encrypted connections between application and database

✅ **Anonymous Web Access**
- Public-facing Application Load Balancer
- No authentication required for website access
- HTTP access via ALB DNS name

✅ **Application Servers**
- EC2 t2.micro instances running Amazon Linux 2023
- Deployed in private subnets across multiple Availability Zones
- SSH access available via provided key pair
- No direct public internet access

✅ **High Availability**
- Application Load Balancer distributing traffic
- Auto Scaling Group with target tracking policy
- Multi-AZ deployment for fault tolerance
- ELB health checks for instance monitoring

✅ **Automatic Scaling**
- Launch template (Project-LT) for consistent instance configuration
- CPU-based target tracking scaling policy
- Configurable min/max capacity

## Architecture Components

### 1. Database Layer
**Amazon RDS MySQL Database**
- Engine: MySQL
- Instance Class: db.t3.micro
- Database Name: `countries`
- Allocated Storage: 20 GB
- Deployment: Private DB subnets (single or multi-AZ)
- Public Access: Disabled
- Security: Restricted to application security group only

**AWS Secrets Manager**
- Secret Name: `rds-mysql-credentials`
- Stores: Database username and password
- Auto-generated secure password
- Retrieved dynamically by PHP application

### 2. Application Layer
**Auto Scaling Group**
- Launch Template: Project-LT (pre-configured with PHP application)
- Instance Type: t2.micro
- Operating System: Amazon Linux 2023
- Minimum Capacity: 2 instances
- Maximum Capacity: 4 instances
- Desired Capacity: 2 instances
- Deployment: Private subnets across multiple AZs
- Health Check: ELB-based with 300s grace period

**Scaling Policy**
- Type: Target Tracking
- Metric: Average CPU Utilization
- Target Value: 50%
- Automatically scales out/in based on demand

### 3. Load Balancing
**Application Load Balancer**
- Type: Internet-facing ALB
- Deployment: Public subnets (minimum 2 AZs)
- Protocol: HTTP (port 80)
- Target Group: Application servers on port 80
- Health Check: HTTP / path, 30s interval

**Target Group Configuration**
- Protocol: HTTP
- Port: 80
- Health Check: 
  - Path: `/`
  - Interval: 30 seconds
  - Healthy Threshold: 2
  - Unhealthy Threshold: 2
  - Timeout: 5 seconds

### 4. Network Architecture
**VPC Configuration**
- Region: us-east-1
- Three subnet pairs (as provisioned):
  - 2 Public Subnets (for ALB)
  - 2-3 Private Subnets (for application servers)
  - 2 Private DB Subnets (for RDS)

**Security Groups**
- **ALB Security Group**: Allows HTTP (port 80) from internet (0.0.0.0/0)
- **Application Security Group**: Allows HTTP from ALB only
- **Database Security Group**: Allows MySQL (port 3306) from application servers only

### 5. Application Code
**PHP Application**
- Pre-installed on Project-LT launch template
- Uses AWS SDK for PHP to retrieve Secrets Manager credentials
- Connects to RDS MySQL database
- Queries `countries` database for application data
- File: `get-parameters.php` handles credential retrieval

## Architecture Diagram

```
                                  Internet
                                     │
                                     ▼
                        ┌────────────────────────┐
                        │  Application Load      │
                        │  Balancer (ALB)        │
                        │  • Public Subnets      │
                        │  • Port 80 (HTTP)      │
                        └────────────┬───────────┘
                                     │
                    ┌────────────────┼────────────────┐
                    ▼                ▼                ▼
            ┌───────────────┐ ┌───────────────┐ ┌───────────────┐
            │  EC2 Instance │ │  EC2 Instance │ │  EC2 Instance │
            │  • Private    │ │  • Private    │ │  • Private    │
            │    Subnet     │ │    Subnet     │ │    Subnet     │
            │  • AZ 1       │ │  • AZ 2       │ │  • AZ 3       │
            └───────┬───────┘ └───────┬───────┘ └───────┬───────┘
                    │                 │                 │
                    └─────────────────┼─────────────────┘
                                      │
                                      ▼
                            ┌─────────────────┐
                            │  RDS MySQL      │
                            │  • Private      │
                            │    DB Subnets   │
                            │  • Port 3306    │
                            └─────────────────┘
                                      │
                                      │ (credentials)
                                      ▼
                            ┌─────────────────┐
                            │  AWS Secrets    │
                            │  Manager        │
                            └─────────────────┘
```

## Implementation Steps

### Step 1: Create RDS MySQL Database
- Deploy RDS instance in private DB subnets
- Generate secure credentials via Secrets Manager
- Configure security group for application-only access
- Set initial database name to `countries`

### Step 2: Create Application Load Balancer
- Deploy ALB in public subnets across 2+ Availability Zones
- Configure target group for port 80 HTTP traffic
- Set up health checks on root path
- Note ALB DNS name for application access

### Step 3: Create Auto Scaling Group
- Reference Project-LT launch template (pre-configured)
- Deploy instances in private subnets
- Attach to ALB target group
- Configure target tracking scaling policy
- Set group size (min: 2, desired: 2, max: 4)

### Step 4: Import Database Data
- Connect to EC2 instance via AWS Systems Manager Session Manager
- Retrieve database credentials from Secrets Manager
- Import SQL dump file into RDS `countries` database
- Verify data import success

## Project Assumptions & Constraints

### Lab Environment
- **Single Region**: Deployed in us-east-1 only
- **No HTTPS**: HTTP-only access (port 80)
- **No Custom Domain**: Access via ALB DNS name
- **Platform**: Amazon Linux 2023 instances
- **Pre-configured Template**: Project-LT launch template provided
- **Subnet Usage**: All three pairs of pre-provisioned subnets utilized
- **IAM Roles**: Uses lab-provided IAM roles

### Security Considerations
- **Production Note**: This implementation allows anonymous access without authentication for educational purposes. In production, implement proper authentication and authorization mechanisms.
- **HTTPS**: Production deployments should use HTTPS with SSL/TLS certificates
- **Secrets Rotation**: Consider implementing automatic secret rotation for production use

## Key Security Features

1. **Network Isolation**
   - Application servers in private subnets (no public IPs)
   - Database in private DB subnets (not publicly accessible)
   - Only ALB exposed to internet

2. **Credential Management**
   - No hardcoded credentials in code
   - Secrets Manager for secure storage
   - Dynamic credential retrieval at runtime

3. **Traffic Control**
   - Security groups enforce least-privilege access
   - ALB → App servers → Database (one-way flow)
   - No direct database access from internet

4. **High Availability**
   - Multi-AZ deployment for fault tolerance
   - Auto Scaling replaces unhealthy instances
   - Load balancer health monitoring

## Infrastructure as Code

**Technology**: Terraform
**Version**: ~> 5.92 (AWS Provider)

### Module Structure
```
.
├── main.tf                 # Root module orchestration
├── variables.tf            # Input variables
├── outputs.tf              # Output values
├── terraform.tfvars        # Variable values
├── terraform.tf            # Provider configuration
├── alb/                    # Application Load Balancer module
│   ├── alb.tf
│   ├── variables.tf
│   └── outputs.tf
├── asg/                    # Auto Scaling Group module
│   ├── asg.tf
│   ├── variables.tf
│   └── outputs.tf
├── rds/                    # RDS Database module
│   ├── rds.tf
│   ├── secrets.tf
│   ├── variables.tf
│   └── outputs.tf
└── vpc/                    # VPC reference module
    ├── vpc.tf
    ├── variables.tf
    └── outputs.tf
```

## Deployment

### Prerequisites
- AWS CLI configured with lab profile
- Terraform installed (>= 1.2)
- Access to AWS lab environment

### Deployment Commands
```bash
# Initialize Terraform
terraform init

# Validate configuration
terraform validate

# Preview changes
terraform plan

# Deploy infrastructure
terraform apply

# View outputs
terraform output
```

### Key Outputs
- `alb_dns_name`: URL to access the web application
- `rds_endpoint`: RDS database endpoint
- `asg_name`: Auto Scaling Group name

## Success Criteria

✅ **Infrastructure Deployed**
- RDS MySQL database operational in private subnets
- Credentials securely stored in Secrets Manager
- ALB accepting traffic and distributing to healthy targets
- Auto Scaling Group maintaining desired instance count

✅ **Application Functional**
- Website accessible via ALB DNS name
- PHP application successfully connecting to database
- Data queries returning expected results
- All application pages loading correctly

✅ **Security Implemented**
- No public IPs on application servers
- Database not publicly accessible
- Credentials retrieved from Secrets Manager (not hardcoded)
- Security groups properly configured

✅ **High Availability Verified**
- Application running across multiple AZs
- Auto Scaling responding to demand changes
- Load balancer health checks passing
- Service remains available during instance failures

## Cost Considerations

**Estimated Monthly Costs (Lab Environment)**:
- RDS db.t3.micro: ~$15-20
- EC2 t2.micro instances (2-4): ~$10-20
- Application Load Balancer: ~$20-25
- Data Transfer: Variable
- **Total**: ~$50-70/month

**Note**: Costs may vary based on actual usage, data transfer, and region.

## Future Enhancements

Consider these improvements for production deployment:

1. **Security**
   - Implement HTTPS with ACM certificates
   - Add WAF (Web Application Firewall)
   - Enable RDS encryption at rest
   - Implement secrets rotation

2. **Monitoring & Logging**
   - CloudWatch Dashboards
   - Application-level logging
   - RDS Performance Insights
   - ALB access logs

3. **Performance**
   - CloudFront CDN for static content
   - ElastiCache for database caching
   - RDS read replicas for read scaling

4. **Disaster Recovery**
   - Multi-Region deployment
   - Automated backups and snapshots
   - RDS automated backups enabled
   - Infrastructure version control

## License

This project is part of the AWS Cloud Architecting course capstone project.

## Author

AWS Cloud Architecting Capstone Project

---

**Last Updated**: November 2024