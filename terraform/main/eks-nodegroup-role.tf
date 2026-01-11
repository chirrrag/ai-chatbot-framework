data "aws_security_group" "prod-eks-sg-nodegroup" {
  id = "sg-083819cb3100fa4dd"
}

data "aws_subnet" "prod-eks-subnet-a-nodegroup" {
  id = "subnet-0e004ee8576a7be24"
}

data "aws_subnet" "prod-eks-subnet-b-nodegroup" {
  id = "subnet-0265fa4284db98cf3"
}

data "aws_iam_role" "prod-eks-nodegroup-role" {
  name = "prod-nodegroup-eks-worker-node"
}

module "prod-eks-nodegroup-role" {
  source           = "../modules/eks-nodegroup/eks-node-role"
  environment_name = "prod-nodegroup"
}