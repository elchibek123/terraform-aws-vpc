########## AWS VPC ##########

variable "cidr_block" {
  type        = string
  description = "This represents VPC CIDR Block"
}

variable "create_internet_gateway" {
  description = "Controls if an Internet Gateway is created for public subnets and the related routes that connect them"
  type        = bool
  default     = null
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

variable "create_public_route_table" {
  description = "Controls if an Public Route Table is created for public subnets"
  type        = bool
  default     = true
}

variable "create_private_route_table" {
  description = "Controls if an Private Route Table is created for private subnets"
  type        = bool
  default     = false
}

variable "azs" {
  description = "A list of availability zones names or ids in the region"
  type        = list(string)
  default     = []
}

########## EIP ##########

variable "create_eip" {
  description = "Set to true if the Elastic IP should be created, false otherwise"
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

variable "env" {
  type        = string
  description = "This is an environment"
  default     = ""
}

variable "region_name" {
  type        = string
  description = "This is a region name"
  default     = ""
}