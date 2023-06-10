data "dns_txt_record_set" "existing_apex_records" {
  host = var.route53_zone_name
}

data "aws_route53_zone" "migadu" {
  name = var.route53_zone_name
}

locals {
  apex_migadu_txt_records = [
    "hosted-email-verify=${var.migadu_domain_verification_id}",
    "v=spf1 include:spf.migadu.com -all",
  ]

  apex_txt_records = distinct(concat(var.merge_apex_text_records ? data.dns_txt_record_set.existing_apex_records.records : [], local.apex_migadu_txt_records))
}
resource "aws_route53_record" "migadu_TXT" {
  zone_id = data.aws_route53_zone.migadu.zone_id
  name    = var.route53_zone_name
  type    = "TXT"
  ttl     = 3600
  records = local.apex_txt_records
}

resource "aws_route53_record" "migadu_MX" {
  zone_id = data.aws_route53_zone.migadu.zone_id
  name    = var.route53_zone_name
  type    = "MX"
  ttl     = 3600
  records = [
    "10 aspmx1.migadu.com",
    "20 aspmx2.migadu.com",
  ]
}

#TODO: This produces an unnecessary 0 record
resource "aws_route53_record" "migadu_domainkeys_CNAME" {
  count   = 4
  zone_id = data.aws_route53_zone.migadu.zone_id
  name    = "key${count.index}._domainkey.${var.route53_zone_name}."
  type    = "CNAME"
  ttl     = 3600
  records = [
    "key${count.index}.${var.route53_zone_name}._domainkey.migadu.com.",
  ]
}

resource "aws_route53_record" "migadu_dmarc_TXT" {
  zone_id = data.aws_route53_zone.migadu.zone_id
  name    = "_dmarc.${var.route53_zone_name}."
  type    = "TXT"
  ttl     = 3600
  records = [
    "v=DMARC1; p=quarantine",
  ]
}

resource "aws_route53_record" "migadu_subdomain_MX" {
  zone_id = data.aws_route53_zone.migadu.zone_id
  name    = "*.${var.route53_zone_name}"
  type    = "MX"
  ttl     = 3600
  records = [
    "10 aspmx1.migadu.com",
    "20 aspmx2.migadu.com",
  ]
}

resource "aws_route53_record" "migadu_autoconfig_CNAME" {
  zone_id = data.aws_route53_zone.migadu.zone_id
  name    = "autoconfig"
  type    = "CNAME"
  ttl     = 3600
  records = [
    "autoconfig.migadu.com.",
  ]
}

resource "aws_route53_record" "migadu_autodiscover_SRV" {
  zone_id = data.aws_route53_zone.migadu.zone_id
  name    = "_autodiscover._tcp.${var.route53_zone_name}"
  type    = "SRV"
  ttl     = 3600
  records = [
    "0 1 443 autodiscover.migadu.com",
  ]
}
resource "aws_route53_record" "migadu_submissions_SRV" {
  zone_id = data.aws_route53_zone.migadu.zone_id
  name    = "_submissions._tcp.${var.route53_zone_name}"
  type    = "SRV"
  ttl     = 3600
  records = [
    "0 1 465 smtp.migadu.com",
  ]
}
resource "aws_route53_record" "migadu_imaps_SRV" {
  zone_id = data.aws_route53_zone.migadu.zone_id
  name    = "_imaps._tcp.${var.route53_zone_name}"
  type    = "SRV"
  ttl     = 3600
  records = [
    "0 1 993 imap.migadu.com",
  ]
}
resource "aws_route53_record" "migadu_pop3s_SRV" {
  zone_id = data.aws_route53_zone.migadu.zone_id
  name    = "_pop3s._tcp.${var.route53_zone_name}"
  type    = "SRV"
  ttl     = 3600
  records = [
    "0 1 995 pop.migadu.com",
  ]
}
