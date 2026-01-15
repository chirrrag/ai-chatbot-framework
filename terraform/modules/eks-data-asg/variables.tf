# variable "environment_name" {
#   type        = string
#   description = "Unique name for the cluster"
# }

# variable "nodes_instance_type" {
#   type        = string
#   description = "Instance type for pool"
# }

# variable "security_groups" {
#   type        = list(string)
#   description = "Security Groups to be applied to pool"
# }

# variable "nodes_in_public_subnet" {
#   default = false
# }

# variable "spot_price" {
#   default = 0
# }

# variable "nodes_root_device_size" {
#   default = 20
# }

# variable "nodes_desired_capacity" {
#   default = 1
# }

# variable "nodes_max_size" {
#   default = 1
# }

# variable "nodes_min_size" {
#   default = 1
# }

# variable "subnets" {
#   type = list(string)
# }

# variable "tags" {
#   description = "A map of tags to add to all resources."
#   type        = map(string)
#   default     = {}
# }

# variable "enable" {
#   default = true
# }

# variable "ec2_keypair" {
#   description = "ssh keypair"
# }

# variable "cluster_version" {}

# variable "eks_role_name" {}

# variable "workload" {}

# variable "arm_nodes" {
#   default = false
# }

# variable "enabled_metrics" {
#   type        = list(string)
#   description = "A list of metrics to collect"
#   default     = ["GroupTotalInstances"]
# }

# variable "suspend_autoscaling_group_processes" {
#   type        = list(string)
#   description = "A list of processes to suspend for the Auto Scaling Group."
#   default     = null
# }


# variable "ebs_volume_type" {
#   type        = string
#   description = "EBS volume type"
#   default     = "gp2"
# }

variable "asg_name" {
  description = "Name of the AutoScaling Group for the NodeGroup"
  type        = string
}

variable "workload_name" {
  description = "Workload or application name"
  type        = string
}

variable "up_min_size" {
  description = "Minimum instance count for scale-up"
  type        = number
}

variable "up_desired_capacity" {
  description = "Desired capacity for scale-up"
  type        = number
}

variable "down_min_size" {
  description = "Minimum instance count for scale-down"
  type        = number
}

variable "down_desired_capacity" {
  description = "Desired capacity for scale-down"
  type        = number
}

variable "max_size" {
  description = "Maximum size of the ASG"
  type        = number
}

variable "up_recurrence" {
  description = "Cron expression for scaling up"
  type        = string
}

variable "down_recurrence" {
  description = "Cron expression for scaling down"
  type        = string
}

variable "time_zone" {
  description = "Timezone for the scaling schedule"
  type        = string
  default     = "Asia/Kolkata"
}
