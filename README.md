# AWS Cloud Architecting Capstone Project

## Objective

Create a highly available, secure PHP application infrastructure with the following requirements:

- Create a database (DB) instance that the PHP application can query
- Deploy a highly available PHP application with load distributed across multiple web servers and Availability Zones
- Use AWS Secrets Manager for secure credential management
- Import data into a MySQL database from a SQL dump file
- Secure the application to prevent public access to application servers and backend systems

## Project Requirements

### Infrastructure Components

1. **Database Layer**
   - RDS MySQL database instance
   - Database credentials stored in AWS Secrets Manager
   - Can be hosted in single or multiple Availability Zones
   - Import data from provided SQL dump file

2. **Application Layer**
   - EC2 instances running PHP application
   - Deployed across multiple Availability Zones
   - No direct public access to application servers
   - Deployed on Amazon Linux 2023

3. **Load Balancing**
   - Application Load Balancer for traffic distribution
   - Distribute load across multiple web servers

4. **Network Architecture**
   - Use all three pairs of provisioned subnets
   - Public subnets for load balancer
   - Private subnets for application and database tiers

5. **Security**
   - Database connection information stored in Secrets Manager
   - Backend systems not publicly accessible
   - Application servers isolated in private subnets
   - Appropriate security group configurations

6. **High Availability**
   - Multi-AZ deployment
   - Auto Scaling Group for application instances
   - Load balancer health checks

## Assumptions & Constraints

### Lab Environment Restrictions

- **Region**: Single AWS Region deployment (multi-Region not required)
- **Domain**: No HTTPS or custom domain required
- **Platform**: Amazon Linux 2023 with provided PHP code
- **Template**: Pre-configured EC2 launch template available
- **IAM**: Use available IAM roles
- **Services**: Limited to services available in lab environment

### Application Requirements

- Use provided PHP code without modifications (unless specifically instructed)
- Website is publicly accessible without authentication
- Database connection retrieved from Secrets Manager
- PHP application queries the RDS MySQL database

## Architecture Overview

```
Internet
    ↓
Application Load Balancer (Public Subnets)
    ↓
Auto Scaling Group (Private Subnets)
    ↓
EC2 Instances (PHP Application)
    ↓
RDS MySQL Database (Private Subnets)
    ↑
AWS Secrets Manager (Credentials)
```

## Key Security Considerations

1. Application servers have no public IP addresses
2. Database is not publicly accessible
3. All database credentials stored in Secrets Manager
4. Security groups restrict traffic to necessary ports only
5. Application retrieves credentials dynamically from Secrets Manager

## Success Criteria

- ✅ RDS MySQL database created and accessible
- ✅ Database credentials managed via Secrets Manager
- ✅ Data successfully imported from SQL dump
- ✅ EC2 instances launched via Auto Scaling Group
- ✅ Application Load Balancer distributes traffic
- ✅ PHP application connects to database using Secrets Manager
- ✅ Website accessible via ALB DNS name
- ✅ No public access to application servers or database
- ✅ Multi-AZ high availability implementation