variable "project" {
  default = "expense"
}

variable "environment" {
  default = "dev"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
  default     = "my-vpc"
}

variable "public_cidr" {
  type    = list(any)
  default = ["10.0.1.0/24", "10.0.2.0/24"]

}

variable "private_cidr" {
  type    = list(any)
  default = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "database_cidr" {
  type    = list(any)
  default = ["10.0.5.0/24", "10.0.6.0/24"]
}

variable "is_peering_required" {
  description = "Flag to enable/disable peering connection"
  type        = bool
  default     = true
}