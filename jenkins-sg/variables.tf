variable "cidr_vpc" {
  description = "cidr vpc"
  type        = string
}

variable "public_subnet" {
  description = "public_subnet"
  type        = list(string)
}

variable "instance_type" {
  description = "jenkins-type"
  type = string
}