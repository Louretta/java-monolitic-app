locals {
  name = "petclinic"
}

data "aws_acm_certificate" "cert" {
  domain = "eloure.co.uk"
  types = ["AMAZON_ISSUED"]
  most_recent = true
  
}
   
module "route53" {
  source = "./module/route53"
  domain_name ="eloure.co.uk"
  nexus_domain_name =  "nexus.eloure.co.uk"
    nexus_elb_dns_name = module.nexus.nexus_elb_dns_name
    nexus_elb_zone_id = module.nexus.nexus_elb_zone_id
    sonarqube_domain_name =  "sonarqube.eloure.co.uk"
    sonarqube_elb_dns_name = module.sonarqube.sonarqube_elb_dns_name
    sonarqube_elb_zone_id = module.sonarqube.sonarqube_elb_zone_id
    jenkins_domain_name = "jenkins.eloure.co.uk"
    jenkins_elb_dns_name = module.jenkins.jenkins_elb_dns_name
    jenkins_elb_zone_id = module.jenkins.jenkins_elb_zone_id
    stage_domain_name = "stage.eloure.co.uk"
    stage_lb_dns_name = module.stage-lb.stage-lb-dns_name
    stage_lb_zone_id = module.stage-lb.stage-lb-zone_id
    prod_domain_name = "prod.eloure.co.uk"
    prod_lb_dns_name = module.prod-lb.prod-lb-dns_name
    prod_lb_zone_id = module.prod-lb.prod-lb-zone_id
}
   
module "vpc" {
    source = "./module/vpc"
    private-subnet = ["10.0.4.0/24","10.0.5.0/24", "10.0.6.0/24"]
    public-subnet = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
    azs = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]

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
    key_name   = module.keypair.public_key-id
    bastion_sg = module.security_group.bastion_sg
    name       = "${local.name}-bastion"

}

module "sonarqube" {
    source = "./module/sonarqube"
    ami    = "ami-01e444924a2233b07"
    subnet_id = module.vpc.public-subnet2
    elb-subnets = [module.vpc.public-subnet1,module.vpc.public-subnet2]
    sonarqube_sg = module.security_group.sonarqube_sg
    keypair = module.keypair.public_key-id
    name = "${local.name}-sonarqube"
    cert-arn = data.aws_acm_certificate.cert.arn
}


module "nexus" {
  source = "./module/nexus"
  ami = "ami-0134dde2b68fe1b07"
  keypair = module.keypair.public_key-id
  nexus_sg = module.security_group.nexus_sg
  subnet_id = module.vpc.public-subnet1
  elb-subnet =  [module.vpc.public-subnet1, module.vpc.public-subnet2]
  name ="${local.name}-nexus"
  cert-arn = data.aws_acm_certificate.cert.arn

  

}

module "ansible" {
  source = "./module/ansible"
  ami = "ami-0134dde2b68fe1b07"
  key_name = module.keypair.public_key-id
  ansible_sg = module.security_group.ansible_sg
  subnet_id = module.vpc.private-subnet1
  name = "${local.name}-ansible"
  
}

module "jenkins" {
  source = "./module/jenkins"
  ami = "ami-0134dde2b68fe1b07"
  key_name = module.keypair.public_key-id
  jenkins_sg = module.security_group.jenkins_sg
  subnet_id = module.vpc.private-subnet1
  elb-subnets = [module.vpc.public-subnet1, module.vpc.public-subnet2]
  name = "${local.name}-jenkins"
  cert-arn = data.aws_acm_certificate.cert.arn
}

module "stage" {
  source = "./module/stage-asg"
  ami ="ami-0134dde2b68fe1b07"
  key-name = module.keypair.public_key-id
  asg-sg = module.security_group.asg_sg 
  asg-stage = "${local.name}-asg-stage"
  vpc-zone-id-stage = [module.vpc.private-subnet1,module.vpc.private-subnet2]
  nexus-stage = module.nexus.nexus_public_ip
  nr-acc-id-stage = "NRAK-HPT5OJANIT515S5M7XMTIRUERKX"
  nr-region-stage = "EU"
  nr-key-stage = "4243993"
  tg-arn = module.stage-lb.stage-tg-arn
  
}
module "prod" {
  source = "./module/prod-asg"
  ami = "ami-0134dde2b68fe1b07"
  vpc-zone-id-prod = [module.vpc.private-subnet1,module.vpc.private-subnet2]
  key-name = module.keypair.public_key-id
  asg-sg = module.security_group.asg_sg
  asg-prod = "${local.name}-asg-prod"
  nexus-prd = module.nexus.nexus_public_ip
  nr-acc-id-prd = "NRAK-HPT5OJANIT515S5M7XMTIRUERKX"
  nr-key-prd = "4243993"
  nr-region-prd = "EU"
  tg-arn = module.prod-lb.prod-tg-arn
}

module "stage-lb" {
  source = "./module/stage-lb"
  vpc_id = module.vpc.vpc_id
  stage-sg = [module.security_group.asg_sg]
  stage-subnet = [module.vpc.public-subnet1,module.vpc.public-subnet2, module.vpc.public-subnet3]
  cert-arn = data.aws_acm_certificate.cert.arn
  stage-lb = "${local.name}-stage-lb"
  
}

module "prod-lb" {
  source = "./module/prod-lb"
  vpc_id = module.vpc.vpc_id
  asg-sg = [module.security_group.asg_sg]
  prod-subnet = [module.vpc.public-subnet1, module.vpc.public-subnet2, module.vpc.public-subnet3]
  cert-arn = data.aws_acm_certificate.cert.arn
  prod-lb = "${local.name}-prod-lb"
  
}