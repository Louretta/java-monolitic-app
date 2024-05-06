
data "aws_route53_zone" "route53_zone" {
  name        = var.domain_name
  private_zone = false
}

# Route53 Record for Nexus
resource "aws_route53_record" "nexus_record" {
  zone_id = data.aws_route53_zone.route53_zone.zone_id
  name    = var.nexus_domain_name
  type    = "A"

  alias {
    name                     = var.nexus_elb_dns_name
    zone_id                  = var.nexus_elb_zone_id
    evaluate_target_health   = true
  }
}

# Route53 Record for SonarQube
resource "aws_route53_record" "sonarqube_record" {
  zone_id = data.aws_route53_zone.route53_zone.zone_id
  name    = var.sonarqube_domain_name
  type    = "A"

  alias {
    name                     = var.sonarqube_elb_dns_name
    zone_id                  = var.sonarqube_elb_zone_id
    evaluate_target_health   = true
  }
}

#create jenkins record 
resource "aws_route53_record" "jenkins-record" {
  zone_id = data.aws_route53_zone.route53_zone.zone_id
  name = var.jenkins_domain_name
  type = "A"

  alias {
    name = var.jenkins_elb_dns_name
    zone_id = var.jenkins_elb_zone_id
    evaluate_target_health = true
  }
  
}

resource "aws_route53_record" "stage_record" {
  zone_id = data.aws_route53_zone.route53_zone.zone_id
  name = var.stage_domain_name
  type = "A"
  alias {
    name    = var.stage_lb_dns_name
    zone_id = var.stage_lb_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "prod_record" {
  zone_id = data.aws_route53_zone.route53_zone.zone_id
  name = var.prod_domain_name
  type = "A"
  alias {
    name    = var.prod_lb_dns_name
    zone_id = var.prod_lb_zone_id
    evaluate_target_health = true
  }
}