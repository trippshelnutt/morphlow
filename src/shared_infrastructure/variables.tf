variable "region" {
  description = "The region where environment is going to be deployed"
  type        = string
  default     = "us-east-1"
}

# VPC variables

variable "vpc_cidr" {
  description = "CIDR range for VPC"
  type        = string
  default     = "10.0.0.0/16"
}
