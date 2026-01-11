data "aws_eks_cluster" "cluster" {
  name = var.environment_name
}

data "aws_iam_role" "iam-role" {
  name = var.eks_role_name
}

locals {
node-userdata = <<USERDATA
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="BOUNDARY"

--BOUNDARY
Content-Type: application/node.eks.aws

apiVersion: node.eks.aws/v1alpha1
kind: NodeConfig
spec:
  cluster:
    name: ${var.environment_name}
    apiServerEndpoint: ${var.apiServerEndpoint}
    certificateAuthority: ${var.certificateAuthority}
    cidr: ${var.cidr}


--BOUNDARY--
USERDATA

tags_dest = ["instance", "volume", "network-interface", "spot-instances-request"]
}

resource "aws_launch_template" "launch-template" {
  name                      = "${var.environment_name}-${var.workload}"

  block_device_mappings {
    device_name             = "/dev/xvda"
    ebs {
      volume_size           = var.nodes_root_device_size
      encrypted             = true
      volume_type           = "gp3"
    }
  }

  disable_api_termination   = "${var.capacity == "SPOT" ? false : true}"
  ebs_optimized             = true
  image_id                  = var.ami_id
  # instance_type             = var.nodes_instance_type
  key_name                  = var.ec2_keypair
  vpc_security_group_ids    = var.security_groups

  dynamic tag_specifications {
    for_each                = toset(local.tags_dest)
    content {
      resource_type         = tag_specifications.key
      tags  = merge({
        Name                = "${var.environment_name}-${var.workload}"
        managed-by          = "terraform"
        ec2-created-by      = "nodegroup"
        os                  = "linux"
    }, var.common_tags)
    }
  }

  user_data = base64encode(local.node-userdata)
}

resource "aws_eks_node_group" "node-group" {
  cluster_name              = var.environment_name
  node_group_name           = "${var.environment_name}-${var.workload}"
  node_role_arn             = data.aws_iam_role.iam-role.arn
  subnet_ids                = var.subnets 
  capacity_type             = var.capacity
  instance_types            = var.nodes_instance_type

  launch_template {
    name                    = aws_launch_template.launch-template.name
    version                 = aws_launch_template.launch-template.latest_version
  }

  scaling_config {
    desired_size            = var.nodes_desired_capacity
    max_size                = var.nodes_max_size
    min_size                = var.nodes_min_size
  }

  update_config {
    max_unavailable         = 1
  }

  depends_on = [
    aws_launch_template.launch-template
  ]

  tags  = merge({
    Name                    = "${var.environment_name}-${var.workload}"
    managed-by              = "terraform"
    ec2-created-by          = "nodegroup"
    os                      = "linux"
  }, var.common_tags)

  labels  = merge({
    Name                    = "${var.environment_name}-${var.workload}"
    managed-by              = "terraform"
  }, var.common_labels)

  dynamic "taint" {
    for_each = var.kubernetes_taints
    content {
      key                   = taint.value["key"]
      value                 = taint.value["value"]
      effect                = taint.value["effect"]
    }
  } 
}

# locals {
#   image = "${var.arm_nodes == true ? "ami-0a24208ea7aae6406" : "ami-0336b0504eb53fcdb"}"
# }
# output "asg_group_name" {
#   value = aws_eks_node_group.node-group.resources.[0].autoscaling_groups[0].name
# }
output "nodegroup_autoscaling_groups" {
  value = aws_eks_node_group.node-group.resources[0].autoscaling_groups
}
