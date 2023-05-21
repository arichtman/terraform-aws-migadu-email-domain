variable "route53_zone_name" {
  description = "Name of the Route53 public hosted zone, usually the TLD FQDN e.g. richtman.com.au"
  type        = string
}

variable "migadu_domain_verification_id" {
  description = "Unique identifier for verifying your domain with Migadu e.g. wve23ado"
  type        = string
}
