variable "cluster-name" {
  default = "prod"
}

variable "cluster-version" {
  default = "1.32"
}

variable "arm-ng-ami-id" {
  default = "ami-017d56d622b423778"
}
variable "amd64-ng-ami-id" {
  default = "ami-0b3b74fd9bf075cae"
}

variable "apiServerEndpoint" {
  description = "API Server Endpoint"
  type        = string
  default     = "https://random-text.sk1.ap-south-1.eks.amazonaws.com"
}

variable "certificateAuthority" {
  description = "Certificate Authority Data"
  type        = string
  default     = "certificate-authority-data-placeholder"
}

variable "cidr" {
  description = "Cluster CIDR"
  type        = string
  default     = "172.20.0.0/16"
}