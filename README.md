# Migadu Domain on Route53

Terraform module for Route53 records to enable a Migadu email domain

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.67.0 |
| <a name="provider_dns"></a> [dns](#provider\_dns) | 3.3.2 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_route53_record.migadu_MX](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.migadu_TXT](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.migadu_autoconfig_CNAME](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.migadu_autodiscover_SRV](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.migadu_dmarc_TXT](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.migadu_domainkeys_CNAME](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.migadu_imaps_SRV](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.migadu_pop3s_SRV](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.migadu_subdomain_MX](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.migadu_submissions_SRV](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_zone.migadu](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |
| [dns_txt_record_set.existing_apex_records](https://registry.terraform.io/providers/hashicorp/dns/latest/docs/data-sources/txt_record_set) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_migadu_domain_verification_id"></a> [migadu\_domain\_verification\_id](#input\_migadu\_domain\_verification\_id) | Unique identifier for verifying your domain with Migadu e.g. wve23ado | `string` | n/a | yes |
| <a name="input_route53_zone_name"></a> [route53\_zone\_name](#input\_route53\_zone\_name) | Name of the Route53 public hosted zone, usually the TLD FQDN e.g. richtman.com.au | `string` | n/a | yes |
| <a name="input_ttl"></a> [ttl](#input\_ttl) | Time to live in seconds for the records | `number` | `3600` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
