locals {
  name = "petclinic"
}

data "aws_acm_certificate" "cert" {
    domain = "dv-gidideals.co.uk"
    types = ["AMAZON_ISSUED"]
    most_recent = true
}

module "vpc" {
    source = "./module/vpc"
    private-subnet = ["10.0.4.0/24","10.0.5.0/24", "10.0.6.0/24"]
    public-subnet = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
    azs = ["eu-central-1a", "eu-west-1b", "eu-west-1c"]
  
}
module "keypair" {
    source = "./module/keypair"
  
}

module "security_group" {
    source = "./module/security-group"
    vpc_id = module.vpc.vpc_id 
}

module "bastion" {
    source    = "./module/bastion"
    ami        = "ami-0134dde2b68fe1b07"
    subnet_id  = module.vpc.public-subnet2
    key_name   = module.keypair.public_key.id
    bastion_sg = module.aws_security_group.bastion_sg
    name       = "${local.name}-bastion"

}

module "sonarqube" {
    source = "./module/sonarqube"
    ami    = "ami-01e444924a2233b07"
    subnet_id = module.vpc.public-subnet2
    elb-subnets = [module.vpc.public-subnet1.module.vpc.public-subnet2]
    sonarqube_sg = module.security_group.sonarqube_sg
    keypair = module.keypair.public_key.id
    name = "${local.name}-sonarqube"
    cert-arn = data.aws_acm_certificate.cert.arn
}

module "nexus" {
  source = "./module/nexus"
  ami = "ami-0134dde2b68fe1b0"
  keypair = module.keypair.public_key
  nexus_sg = module.security_group.nexus_sg
  subnet_id = module.vpc.public-subnet1
  elb-subnet =  [module.vpc.public-subnet1, module.vpc.public-subnet2]
  name ="${local.name}-nexus"
  cert-arn = data.aws_acm_certificate.cert.arn

}
