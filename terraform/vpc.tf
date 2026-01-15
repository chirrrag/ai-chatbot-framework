module "vpc" {
  source = "./modules/vpc"

  name       = "${var.cluster_name}-${var.environment}"
  vpc_cidr   = var.vpc_cidr
  enable_nat_gateway = var.enable_nat_gateway
  single_nat_gateway = var.single_nat_gateway

  # Calculate subnet CIDRs - /20 subnets for each AZ
  public_subnet_cidrs = [
    cidrsubnet(var.vpc_cidr, 4, 0),  # 10.0.0.0/20
    cidrsubnet(var.vpc_cidr, 4, 1),  # 10.0.16.0/20
    cidrsubnet(var.vpc_cidr, 4, 2),  # 10.0.32.0/20
  ]

  private_subnet_cidrs = [
    cidrsubnet(var.vpc_cidr, 4, 4),  # 10.0.64.0/20
    cidrsubnet(var.vpc_cidr, 4, 5),  # 10.0.80.0/20
    cidrsubnet(var.vpc_cidr, 4, 6),  # 10.0.96.0/20
  ]

}

