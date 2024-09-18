variable "linode_token" {
  type        = string
  description = "Linode Token"
}

variable "root_password" {
  type        = string
  description = "Root password for Linode Instances"
}

variable "ssh_key_pub" {
  type        = string
  description = "SSH Public Key"
}

variable "ssh_key" {
  type        = string
  description = "SSH Private Key"
}

variable "linode_username" {
  type        = string
  description = "Username to be used as noted in the Linode profile"
  default     = "testuser"
}

variable "linode_region" {
  type        = string
  description = "Linode region where infrastructure if being deployed."
  default     = "us-sea"
}

variable "node_count" {
  type        = number
  description = "Number of nodes to deploy."
}

variable "linode_image" {
  type        = string
  description = "Linode base image to use on Linode instances"
  default     = "linode/debian11"
}

variable "linode_type" {
  type        = string
  description = "Linode instance type to deploy"
  default     = "g6-nanode-1"
}

variable "domain" {
  type        = string
  description = "Application domain"
}

variable "email" {
  type        = string
  description = "Domain owner email address"
}

variable "hq_home_ip" {
  type        = string
  description = "Home Public IP to troubleshoot nodes over SSH"
  default     = ""
}