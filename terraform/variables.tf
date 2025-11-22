variable "name" {
  type = string
}
variable "vpc_cidr" {
    type = string
}
variable "public_subnet_cidrs" {
    type = list(string)
}
variable "azs" {
    type = list(string)
}
variable "key_name" {
  type = string
}

variable "alert_email" {
  type = string
}
