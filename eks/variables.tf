variable "cidr_vpc" {
  description = "cidr vpc"
  type        = string
}

variable "private_subnet" {
  description = "private_subnet"
  type        = list(string)
}

variable "public_subnet" {
  description = "public_subnet"
  type        = list(string)
}