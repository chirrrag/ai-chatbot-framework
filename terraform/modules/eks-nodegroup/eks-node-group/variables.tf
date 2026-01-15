variable "environment_name" {
  type        = string
  description = "Unique name for the cluster"
}

variable "workload" {}

variable "eks_role_name" {}

variable "arm_nodes" {
}

variable "capacity" {}

variable "cluster_version" {}

# variable "spot_instance" {
#   default = 0
# }

variable "nodes_instance_type" {
  type        = list(string)
  description = "Instance type for pool"
}

variable "ec2_keypair" {
  description = "ssh keypair"
}

variable "security_groups" {
  type        = list(string)
  description = "Security Groups to be applied to pool"
}

variable "nodes_root_device_size" {
  default = 20
}

variable "subnets" {
  type = list(string)
}

variable "nodes_desired_capacity" {
  default = 1
}

variable "nodes_max_size" {
  default = 1
}

variable "nodes_min_size" {
  default = 1
}

variable "kubernetes_taints" {
  type = list(object({
    key    = string
    value  = string
    effect = string
  }))
  description = <<-EOT
    List of `key`, `value`, `effect` objects representing Kubernetes taints.
    `effect` must be one of `NO_SCHEDULE`, `NO_EXECUTE`, or `PREFER_NO_SCHEDULE`.
    `key` and `effect` are required, `value` may be null.
    EOT
  default     = []
}

variable "common_tags" {
  type = map
}

variable "common_labels" {
  type = map
}

variable "ami_id" {}

variable "apiServerEndpoint" {
  description = "API Server Endpoint"
  type       = string
}

variable "certificateAuthority" {
  description = "Certificate Authority Data"
  type       = string
}

variable "cidr" {
  description = "Cluster CIDR"
  type       = string
}