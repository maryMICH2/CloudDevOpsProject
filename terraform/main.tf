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

module "eks" {
  source  = "/home/ali/nti-graduation-project/terraform/modules/eks"

  cluster_name    = "${var.name}-cluster"
  cluster_version = "1.30"

  vpc_id     = module.network.vpc_id
  subnet_ids = module.network.public_subnet_ids

  # Use pre-existing role
  cluster_role_arn = "arn:aws:iam::189167246439:role/LabRole"
  node_role_arn    = "arn:aws:iam::189167246439:role/LabRole"

  # Node group configuration
  instance_types = ["t3.micro"]
  desired_size   = 2
  min_size       = 1
  max_size       = 2
}



# MONITORING MODULE (SNS + CloudWatch)
module "monitoring" {
  source = "/home/ali/nti-graduation-project/terraform/modules/mointoring"

  name              = var.name
  alert_email       = var.alert_email
  jenkins_master_id = module.server.jenkins_master_id
  jenkins_worker_id = module.server.jenkins_worker_id
}
