module "prod-amd64-stateless-ondemand-nodegroup-blue-two" {
  source = "../modules/eks-nodegroup/eks-node-group"

  //Common Vars
  cluster_version        = var.cluster-version
  environment_name       = "prod"
  apiServerEndpoint      = var.apiServerEndpoint
  certificateAuthority   = var.certificateAuthority
  cidr                   = var.cidr
  workload               = "amd64-stateless-ondemand-nodegroup-blue-two"
  arm_nodes              = false
  nodes_instance_type    = ["t3.medium", "t3.large"]
  capacity               = "ON_DEMAND"
  ec2_keypair            = "portalMum2"
  security_groups        = ["${data.aws_security_group.prod-eks-sg-nodegroup.id}"]
  nodes_root_device_size = 50
  subnets                = ["${data.aws_subnet.prod-eks-subnet-a-nodegroup.id}", "${data.aws_subnet.prod-eks-subnet-b-nodegroup.id}"]
  eks_role_name          = data.aws_iam_role.prod-eks-nodegroup-role.name
  ami_id                 = var.amd64-ng-ami-id
  # ami_id                    = "ami-0cc185ec5425c42a4" # 1.30
  # Update this ami ID based on this parameter /aws/service/eks/optimized-ami/${cluster_version}/amazon-linux-2/recommended/image_id
  # You can find the ami id value in SSM Parameter Store

  nodes_desired_capacity = 2
  nodes_max_size         = 5
  nodes_min_size         = 2

  kubernetes_taints = [
    {
      key    = "arch"
      value  = "amd64"
      effect = "NO_SCHEDULE"
    }
  ]

  common_tags = {
    Team      = "k8s"
    lifecycle = "ondemand"
    Env       = "prod"
    arch      = "amd64"
    product   = "shared"
  }

  common_labels = {
    Name     = "prod-amd64-stateless-ondemand-nodegroup-blue-two"
    Env      = "prod"
    arch     = "amd64"
    capacity = "ondemand"
  }
}

# ml workload
module "prod-gpu-ondemand-nodegroup" {
  source = "../modules/eks-nodegroup/eks-node-group"

  //Common Vars
  cluster_version        = var.cluster-version
  environment_name       = "prod"
  apiServerEndpoint      = var.apiServerEndpoint
  certificateAuthority   = var.certificateAuthority
  cidr                   = var.cidr
  workload               = "gpu-ondemand-nodegroup"
  arm_nodes              = false
  nodes_instance_type    = ["c5.xlarge", "m5.large"]
  capacity               = "ON_DEMAND"
  ec2_keypair            = "portalMum2"
  security_groups        = ["${data.aws_security_group.prod-eks-sg-nodegroup.id}"]
  nodes_root_device_size = 50
  subnets                = ["${data.aws_subnet.prod-eks-subnet-b-nodegroup.id}"]
  eks_role_name          = data.aws_iam_role.prod-eks-nodegroup-role.name
  ami_id                 = "ami-0f3a034f6bdacabf8"
  # Update this ami ID based on this parameter /aws/service/eks/optimized-ami/${cluster_version}/amazon-linux-2/recommended/image_id
  # You can find the ami id value in SSM Parameter Store

  nodes_desired_capacity = 1
  nodes_max_size         = 3
  nodes_min_size         = 1

  kubernetes_taints = [
    {
      key    = "gpu"
      value  = "true"
      effect = "NO_SCHEDULE"
    }
  ]

  common_tags = {
    Team      = "ftl"
    service   = "gpu"
    lifecycle = "spot"
    Env       = "prod"
    arch      = "amd64"
    product   = "shared"
  }

  common_labels = {
    Name    = "prod-gpu-spot-nodegroup"
    Env     = "prod"
    service = "gpu"
    arch    = "amd64"
  }
}