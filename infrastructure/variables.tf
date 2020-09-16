variable "region" {
  default = "us-east-1"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
  description = "VPC CIDR Block"
}

variable "public_subnet_cidr_1" {
  description = "Public subnet CIDR Block 1"
}

variable "public_subnet_cidr_2" {
  description = "Public subnet CIDR Block 2"
}

variable "public_subnet_cidr_3" {
  description = "Public subnet CIDR Block 3"
}

variable "private_subnet_cidr_1" {
  description = "Private subnet CIDR Block 1"
}

variable "private_subnet_cidr_2" {
  description = "Private subnet CIDR Block 2"
}

variable "private_subnet_cidr_3" {
  description = "Private subnet CIDR Block 3"
}
