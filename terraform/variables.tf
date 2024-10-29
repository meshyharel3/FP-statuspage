variable "aws_region" {
  description = "The AWS region to deploy resources."
  type        = string
}
# Define variable for the access key
variable "aws_access_key" {
  description = "The AWS access key."
  type        = string
  sensitive   = true
}
# Define variable for the secret key
variable "aws_secret_key" {
  description = "The AWS secret key."
  type        = string
  sensitive   = true
}

# Define variable for the EKS cluster name
variable "eks_cluster_name" {
  type        = string
  description = "The name of the EKS cluster"
}

# Define variable for the Node Group name
variable "node_group_name" {
  type        = string
  description = "The name of the node group for the EKS cluster"
}

# Define list of private subnet IDs
variable "private_subnet_ids" {
  type        = list(string)
  description = "List of private subnet IDs for the EKS cluster"
}

# Define application node group capacity
variable "app_desired_capacity" {
  type        = number
  description = "Desired number of nodes in the application node group"
  default     = 2
}

variable "app_max_size" {
  type        = number
  description = "Maximum number of nodes in the application node group"
  default     = 3
}

variable "app_min_size" {
  type        = number
  description = "Minimum number of nodes in the application node group"
  default     = 1
}

#variable "ssh_key_name" {
 # description = "The name of the SSH key pair to use for the node group."
#}
