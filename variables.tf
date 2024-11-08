########## AWS VPC ##########

variable "cidr_block" {
  type        = string
  description = "This represents VPC CIDR Block"
}

variable "create_internet_gateway" {
  description = "Controls if an Internet Gateway is created for public subnets and the related routes that connect them"
  type        = bool
  default     = true
}

variable "enable_dns_hostnames" {
  description = "Enabling DNS hostnames"
  type        = bool
  default     = false
}

variable "enable_dns_support" {
  description = "Enabling DNS support"
  type        = bool
  default     = true
}

########## AWS VPC Subnets ##########

variable "public_subnets" {
  type        = list(string)
  description = "This represents public subnet CIDR block"
  default     = []
}

variable "private_subnets" {
  type        = list(string)
  description = "This represents private subnet CIDR block"
  default     = []
}

variable "create_public_subnets" {
  description = "Set to true if the public subnets should be created, false otherwise"
  type        = bool
  default     = true
}

variable "create_private_subnets" {
  description = "Set to true if the private subnets should be created, false otherwise"
  type        = bool
  default     = false
}

variable "azs" {
  description = "A list of availability zones names or ids in the region"
  type        = list(string)
  default     = []
}

variable "map_public_ip_on_launch" {
  description = "Specify true to indicate that instances launched into the subnet should be assigned a public IP address. Default is `false`"
  type        = bool
  default     = null
}

########## NAT Gateway ##########

variable "create_nat" {
  description = "Set to true if the NAT Gateway should be created, false otherwise"
  type        = bool
  default     = false
}

########## Tags ##########

variable "tags" {
  type        = map(string)
  description = "These are resource tags"
  default     = {}
}

variable "environment" {
  type        = string
  description = "This is an environment"
  default     = ""
}

variable "aws_region" {
  type        = string
  description = "This is a region name"
  default     = ""
}