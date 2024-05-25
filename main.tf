locals {
  name = "petclinic"
}

data "aws_acm_certificate" "cert" {
  domain = "dv-gidideals.co.uk"
  types = ["AMAZON_ISSUED"]
  most_recent = true
  
}
   
module "route53" {
  source = "./module/route53"
  domain_name ="dv-gidideals.co.uk"
  nexus_domain_name =  "nexus.dv-gidideals.co.uk"
    nexus_elb_dns_name = module.nexus.nexus_elb_dns_name
    nexus_elb_zone_id = module.nexus.nexus_elb_zone_id
    sonarqube_domain_name =  "sonarqube.dv-gidideals.co.uk"
    sonarqube_elb_dns_name = module.sonarqube.sonarqube_elb_dns_name
    sonarqube_elb_zone_id = module.sonarqube.sonarqube_elb_zone_id
    jenkins_domain_name = "jenkins.dv-gidideals.co.uk"
    jenkins_elb_dns_name = module.jenkins.jenkins_elb_dns_name
    jenkins_elb_zone_id = module.jenkins.jenkins_elb_zone_id
    stage_domain_name = "stage.dv-gidideals.co.uk"
    stage_lb_dns_name = module.stage-lb.stage-lb-dns_name
    stage_lb_zone_id = module.stage-lb.stage-lb-zone_id
    prod_domain_name = "prod.dv-gidideals.co.uk"
    prod_lb_dns_name = module.prod-lb.prod-lb-dns_name
    prod_lb_zone_id = module.prod-lb.prod-lb-zone_id
}
   
module "vpc" {
    source = "./module/vpc"
    private-subnet = ["10.0.4.0/24","10.0.5.0/24", "10.0.6.0/24"]
    public-subnet = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
    azs = ["eu-north-1a", "eu-north-1b", "eu-north-1c"]

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
    ami        = "ami-03035978b5aeb1274"
    subnet_id  = module.vpc.public-subnet2
    key_name   = module.keypair.public_key-id
    bastion_sg = module.security_group.bastion_sg
    name       = "${local.name}-bastion"
    private_key = module.keypair.private_key_pem

}

module "sonarqube" {
    source = "./module/sonarqube"
    ami    = "ami-0705384c0b33c194c"
    subnet_id = module.vpc.public-subnet2
    elb-subnets = [module.vpc.public-subnet1,module.vpc.public-subnet2, module.vpc.public-subnet3]
    sonarqube_sg = module.security_group.sonarqube_sg
    keypair = module.keypair.public_key-id
    name = "${local.name}-sonarqube"
    cert-arn = data.aws_acm_certificate.cert.arn
    nr-acc-id = 4459411
    nr-key = "NRAK-DNXE8NC150GJMRU00175ONBQOBB"
    nr-region = "EU"
}


module "nexus" {
  source = "./module/nexus"
  ami = "ami-03035978b5aeb1274"
  keypair = module.keypair.public_key-id
  nexus_sg = module.security_group.nexus_sg
  subnet_id = module.vpc.public-subnet1
  elb-subnet =  [module.vpc.public-subnet1, module.vpc.public-subnet2,module.vpc.public-subnet3]
  name ="${local.name}-nexus"
  cert-arn = data.aws_acm_certificate.cert.arn
  nr-acc-id = 4459411
  nr-key ="NRAK-DNXE8NC150GJMRU00175ONBQOBB"
  nr-region = "EU"

  

}

module "ansible" {
  source = "./module/ansible"
  ami = "ami-03035978b5aeb1274"
  key_name = module.keypair.public_key-id
  ansible_sg = module.security_group.ansible_sg
  subnet_id = module.vpc.private-subnet1
  name = "${local.name}-ansible"
  staging-discovery-script = "${path.root}/module/ansible/stage-inventory-bash-script.sh"
  prod-discovery-script = "${path.root}/module/ansible/prod-inventory-bash-script.sh"
  staging-MyPlaybook = "${path.root}/module/ansible/stage-playbook.yaml"
  prod-MyPlaybook = "${path.root}/module/ansible/prod-playbook.yaml"
  private_key = module.keypair.private_key_pem
  nr-acc-id = 4459411
  nr-key = "NRAK-DNXE8NC150GJMRU00175ONBQOBB"
  nr-region = "EU"
  nexus-ip = module.nexus.nexus_public_ip

  
}

module "jenkins" {
  source       = "./module/jenkins"
  ami          = "ami-03035978b5aeb1274"
  key_name      = module.keypair.public_key-id
  jenkins_sg    = module.security_group.jenkins_sg
  subnet_id     = module.vpc.private-subnet1
  elb-subnets   = [module.vpc.public-subnet1, module.vpc.public-subnet2, module.vpc.public-subnet3]
  name          = "${local.name}-jenkins"
  cert-arn      = data.aws_acm_certificate.cert.arn
  nr-acc-id      = 4459411
  nr-key         ="NRAK-DNXE8NC150GJMRU00175ONBQOBB"
  nr-region      ="EU"
  nexus-ip       = module.nexus.nexus_public_ip
}

module "stage" {
  source = "./module/stage-asg"
  ami ="ami-03035978b5aeb1274"
  key-name = module.keypair.public_key-id
  asg-sg = module.security_group.asg_sg 
  asg-stage = "${local.name}-stage-asg"
  vpc-zone-id-stage = [module.vpc.private-subnet1,module.vpc.private-subnet2,module.vpc.private-subnet3]
  nexus-stage = module.nexus.nexus_public_ip
  nr-acc-id-stage = 4459411
  nr-region-stage = "EU"
  nr-key-stage = "NRAK-DNXE8NC150GJMRU00175ONBQOBB"
  tg-arn = module.stage-lb.stage-tg-arn
  
}
module "prod" {
  source = "./module/prod-asg"
  ami = "ami-03035978b5aeb1274"
  vpc-zone-id-prod = [module.vpc.private-subnet1,module.vpc.private-subnet2,module.vpc.private-subnet3]
  key-name = module.keypair.public_key-id
  asg-sg = module.security_group.asg_sg
  asg-prod = "${local.name}-prod-asg"
  nexus-prd = module.nexus.nexus_public_ip
  nr-acc-id-prd = 4459411
  nr-key-prd = "NRAK-DNXE8NC150GJMRU00175ONBQOBB"
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

module "rds" {
  source = "./module/rds"
  db-subnet-grp ="db-subnet-group"
  subnet =[module.vpc.private-subnet1, module.vpc.private-subnet2, module.vpc.private-subnet3]
  security_group_mysql_sg = module.security_group.rds-sg
  db-name = "petclinic"
  db-username = data.vault_generic_secret.vault-secret.data["username"]
  db-password = data.vault_generic_secret.vault-secret.data["password"]
 tag-name ="${local.name}-rds"
  
  
}

data "vault_generic_secret" "vault-secret" {
  path = "secret/database"
  
}