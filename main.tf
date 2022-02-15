provider "aws" {
  region = var.region
}

module "vpc" {
  source              = "./modules/networking"
  region              = "eu-west-3"
  vpc_cidr            = "10.10.0.0/16"
  name                = "atmj-vpc"
  env                 = "atmj"
  public_subnets_cidr = ["10.10.0.0/24", "10.10.1.0/24", "10.10.2.0/24"]
  availability_zones  = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
}

module "ec2" {
  source        = "./modules/ec2"
  vpc_sg_id     = [module.vpc.sg-id]
  public_subnet = module.vpc.public_subnet_id

}
