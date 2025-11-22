# NETWORK MODULE
module "network" {
  source = "/home/ali/nti-graduation-project/terraform/modules/network"

  name                = var.name
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidrs = var.public_subnet_cidrs
  azs                 = var.azs
}

# SERVER MODULE (EC2 + SG) 
module "server" {
  source = "/home/ali/nti-graduation-project/terraform/modules/server"

  name                = var.name
  vpc_id              = module.network.vpc_id
  public_subnet_ids = module.network.public_subnet_ids
  key_name            = var.key_name
}

# MONITORING MODULE (SNS + CloudWatch)
module "monitoring" {
  source = "/home/ali/nti-graduation-project/terraform/modules/mointoring"

  name              = var.name
  alert_email       = var.alert_email
  jenkins_master_id = module.server.jenkins_master_id
  jenkins_worker_id = module.server.jenkins_worker_id
}