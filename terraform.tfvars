// Database configuration 
db_subnet_group_name = "c166539a4285125l12805507t1w952789226688-dbsubnetgroup-2epbqoat5mtm"
db_sg_id             = "sg-0ec1c9aad40d7ab25"


// VPC configuration
vpc_id = "vpc-0b67e97f2001ce6fa"


// ALB configuration
alb_sg_id = "sg-0e3c93ce8641e41b3" // ALBSG - dedicated for ALB
public_subnet_ids = [
  "subnet-02e93c7287b9c72ed", // Public Subnet 1
  "subnet-0482740dc50cd7dda"  // Public Subnet 2
]

// AGS configuration
private_subnet_ids = [
  "subnet-0624ff10dee3597be",
  "subnet-0abe23b636e95e4ab"
]

// App configuration
//app_subnet_id = ""
app_sg_id = "sg-0b9e50ca891dbef50"