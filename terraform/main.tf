module "network" {
  source = "./modules/network"

  project_name               = var.project_name
  vpc_cidr                   = var.vpc_cidr
  public_subnet_1a_cidr      = var.public_subnet_1a_cidr
  public_subnet_1c_cidr      = var.public_subnet_1c_cidr
  private_app_subnet_1a_cidr = var.private_app_subnet_1a_cidr
  private_app_subnet_1c_cidr = var.private_app_subnet_1c_cidr
  private_db_subnet_1a_cidr  = var.private_db_subnet_1a_cidr
  private_db_subnet_1c_cidr  = var.private_db_subnet_1c_cidr
}

module "security" {
  source = "./modules/security"

  project_name = var.project_name
  vpc_id       = module.network.vpc_id
}

module "compute" {
  source = "./modules/compute"

  project_name           = var.project_name
  private_app_subnet_ids = module.network.private_app_subnet_ids
  ec2_sg_id              = module.security.ec2_sg_id
}
