variable "route53_zone_name" {
  description = "Name of the Route53 public hosted zone, usually the FQDN e.g. richtman.com.au"
  type        = string
}

variable "migadu_domain_verification_id" {
  description = "Unique identifier for verifying your domain with Migadu e.g. wve23ado"
  type        = string
}

variable "ttl" {
  description = "Time to live in seconds for the records"
  type        = number
  default     = 3600
}
variable "merge_apex_text_records" {
  description = "Whether or not to merge with existing apex domain TXT entries"
  type        = bool
  default     = true
}
