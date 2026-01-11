# data "aws_eks_cluster" "cluster" {
#   name = var.environment_name
# }

# locals {
#   node-userdata = <<USERDATA
# #!/bin/bash -xe
# FIXED_NODE_LABELS="aws.eks/cluster=${var.environment_name}"
# INSTANCE_ID=`wget -qO- http://instance-data/latest/meta-data/instance-id`
# REGION=`wget -qO- http://instance-data/latest/meta-data/placement/availability-zone | sed 's/.$//'`
# EKS_LABELS=`aws ec2 describe-tags --region $REGION --filter "Name=resource-id,Values=$INSTANCE_ID" --output=json | jq --raw-output '.Tags[] | select(.Key=="aws.eks/node/label") | .Value'`
# EKS_TAINTS=`aws ec2 describe-tags --region $REGION --filter "Name=resource-id,Values=$INSTANCE_ID" --output=json | jq --raw-output '.Tags[] | select(.Key=="aws.eks/node/taint") | .Value'`
# EXTRA_ARGS=""
# if [ ! -z "$EKS_TAINTS" ]; then EXTRA_ARGS=$EXTRA_ARGS" --register-with-taints="$EKS_TAINTS; fi
# if [ ! -z "$EKS_LABELS" ]; then EXTRA_ARGS=$EXTRA_ARGS" --node-labels="$EKS_LABELS,$FIXED_NODE_LABELS; else EXTRA_ARGS=$EXTRA_ARGS" --node-labels="$FIXED_NODE_LABELS; fi
# echo "net.core.netdev_max_backlog=30000" >> /etc/sysctl.conf
# echo "net.core.rmem_max=16777216" >> /etc/sysctl.conf
# echo "net.core.somaxconn=16096" >> /etc/sysctl.conf
# echo "net.core.wmem_max=16777216" >> /etc/sysctl.conf
# echo "net.ipv4.ip_local_port_range=1024 65535" >> /etc/sysctl.conf
# echo "net.ipv4.tcp_tw_reuse=1" >> /etc/sysctl.conf
# echo "net.ipv4.neigh.default.gc_thresh1=8096" >> /etc/sysctl.conf
# echo "net.ipv4.neigh.default.gc_thresh2=12288" >> /etc/sysctl.conf
# echo "net.ipv4.neigh.default.gc_thresh3=16384" >> /etc/sysctl.conf
# echo "net.ipv4.tcp_fin_timeout=15" >> /etc/sysctl.conf
# echo "net.ipv4.tcp_max_syn_backlog=20480" >> /etc/sysctl.conf
# echo "net.ipv4.tcp_max_tw_buckets=400000" >> /etc/sysctl.conf
# echo "net.ipv4.tcp_no_metrics_save=1" >> /etc/sysctl.conf
# echo "net.ipv4.tcp_rmem=4096 87380 16777216" >> /etc/sysctl.conf
# echo "net.ipv4.tcp_syn_retries=2" >> /etc/sysctl.conf
# echo "net.ipv4.tcp_synack_retries=2" >> /etc/sysctl.conf
# echo "net.ipv4.tcp_wmem=4096 65536 16777216" >> /etc/sysctl.conf
# echo "fs.aio-max-nr = 1048576" >> /etc/sysctl.conf
# sysctl -p /etc/sysctl.conf
# mv /etc/docker/daemon.json /tmp/daemon-tmp.json
# jq '. + {"registry-mirrors": ["http://test-docker-cache.tools.freighttiger.com"]}' /tmp/daemon-tmp.json  > /etc/docker/daemon.json
# rm /tmp/daemon-tmp.json
# systemctl daemon-reload
# systemctl restart docker
# yum -y install chrony && service chronyd restart
# /etc/eks/bootstrap.sh --apiserver-endpoint '${data.aws_eks_cluster.cluster.endpoint}' --b64-cluster-ca '${data.aws_eks_cluster.cluster.certificate_authority[0].data}' --kubelet-extra-args "$EXTRA_ARGS" '${var.environment_name}'
# USERDATA
# }

# resource "aws_iam_instance_profile" "node" {
#   name = "${var.environment_name}-${var.workload}-node"
#   role = var.eks_role_name
# }

# resource "aws_launch_configuration" "nodes" {
#   count                       = var.enable ? 1 : 0
#   iam_instance_profile        = aws_iam_instance_profile.node.name
#   image_id                    = local.image
#   instance_type               = var.nodes_instance_type
#   name_prefix                 = "${var.environment_name}-${var.workload}-nodes"
#   security_groups             = var.security_groups
#   user_data_base64            = base64encode(local.node-userdata)
#   associate_public_ip_address = var.nodes_in_public_subnet

#   spot_price = var.spot_price > 0 ? var.spot_price : null

#   key_name = var.ec2_keypair

#   root_block_device {
#     volume_size = var.nodes_root_device_size
#     volume_type = "${var.ebs_volume_type}"
#     encrypted   = true
#   }

#   lifecycle {
#     create_before_destroy = true
#     ignore_changes        = [image_id]
#   }
# }

# resource "aws_autoscaling_group" "nodes" {
#   count                = var.enable ? 1 : 0
#   desired_capacity     = var.nodes_desired_capacity
#   launch_configuration = aws_launch_configuration.nodes[0].id
#   max_size             = var.nodes_max_size
#   min_size             = var.nodes_min_size
#   name                 = "${var.environment_name}-${var.workload}-nodes"
#   vpc_zone_identifier  = var.subnets

#   lifecycle {
#     create_before_destroy = true
#     ignore_changes        = [desired_capacity]
#   }

#   enabled_metrics = var.enabled_metrics
#   metrics_granularity = "1Minute"

#   suspended_processes = var.suspend_autoscaling_group_processes

#   tags = concat(
#     [
#       {
#         key                 = "Name"
#         value               = "${var.environment_name}-${var.workload}-nodes"
#         propagate_at_launch = true
#       },
#       {
#         key                 = "kubernetes.io/cluster/${var.environment_name}"
#         value               = "owned"
#         propagate_at_launch = true
#       },
#       {
#         key                 = "k8s.io/cluster/${var.environment_name}"
#         value               = "owned"
#         propagate_at_launch = true
#       },
#       {
#         key                 = "Team"
#         value               = "devops"
#         propagate_at_launch = true
#       },
#       {
#         key                 = "Service"
#         value               = "applications"
#         propagate_at_launch = true
#       },
#     ],
#     local.asg_tags
#   )
# }

# locals {
#   asg_tags = [
#     for item in keys(var.tags) :
#     map(
#       "key", item,
#       "value", element(values(var.tags), index(keys(var.tags), item)),
#       "propagate_at_launch", "true"
#     )
#     if item != "Name"
#   ]

#   image = "${var.arm_nodes == true ? data.aws_ssm_parameter.eks_ami_arm.value : data.aws_ssm_parameter.eks_ami_x86.value}"
# }


resource "aws_autoscaling_schedule" "scale_up_morning" {
  scheduled_action_name  = "${var.workload_name}-scale-up"
  min_size               = var.up_min_size
  desired_capacity       = var.up_desired_capacity
  max_size               = var.max_size
  recurrence             = var.up_recurrence
  time_zone              = var.time_zone
  autoscaling_group_name = var.asg_name
}

resource "aws_autoscaling_schedule" "scale_down_night" {
  scheduled_action_name  = "${var.workload_name}-scale-down"
  min_size               = var.down_min_size
  desired_capacity       = var.down_desired_capacity
  max_size               = var.max_size
  recurrence             = var.down_recurrence
  time_zone              = var.time_zone
  autoscaling_group_name = var.asg_name
}
