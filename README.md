[![License](https://img.shields.io/badge/license-MIT-blue)](https://opensource.org/licenses/MIT) [![Work In Progress](https://img.shields.io/badge/Status-Work%20In%20Progress-yellow)](https://guide.unitvectorylabs.com/bestpractices/status/#work-in-progress)

# jwks-catalog-crawler-tofu

OpenTofu module for deploying jwks-catalog-crawler to GCP

## References

- [jwks-catalog-crawler](https://github.com/UnitVectorY-Labs/jwks-catalog-crawler): Extracts URLs from jwks-catalog and publishes crawl requests to http-response-collector for HTTP response and header collection.
- [jwks-catalog-crawler-tofu](https://github.com/UnitVectorY-Labs/jwks-catalog-crawler-tofu): OpenTofu module for deploying jwks-catalog-crawler to GCP

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_cloud_run_v2_job.default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_run_v2_job) | resource |
| [google_project_service.cloudscheduler](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service) | resource |
| [google_project_service.run](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service) | resource |
| [google_pubsub_topic_iam_member.response](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/pubsub_topic_iam_member) | resource |
| [google_service_account.cloud_run_sa](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_artifact_registry_host"></a> [artifact\_registry\_host](#input\_artifact\_registry\_host) | The name of the Artifact Registry repository | `string` | `"us-docker.pkg.dev"` | no |
| <a name="input_artifact_registry_name"></a> [artifact\_registry\_name](#input\_artifact\_registry\_name) | The name of the Artifact Registry repository | `string` | n/a | yes |
| <a name="input_artifact_registry_project_id"></a> [artifact\_registry\_project\_id](#input\_artifact\_registry\_project\_id) | The project to use for Artifact Registry. Will default to the project\_id if not set. | `string` | `null` | no |
| <a name="input_http_response_collector_pubsub_topic_name"></a> [http\_response\_collector\_pubsub\_topic\_name](#input\_http\_response\_collector\_pubsub\_topic\_name) | The name of the pubsub topic for the http-response-collector | `string` | `"http-response-collector-request"` | no |
| <a name="input_jwks_catalog_crawler_tag"></a> [jwks\_catalog\_crawler\_tag](#input\_jwks\_catalog\_crawler\_tag) | The tag for the jwks-catalog-crawler image to deploy | `string` | `"dev"` | no |
| <a name="input_jwks_catalog_url"></a> [jwks\_catalog\_url](#input\_jwks\_catalog\_url) | The URL to the JWKS catalog YAML file | `string` | `"https://raw.githubusercontent.com/UnitVectorY-Labs/jwks-catalog/refs/heads/main/data/services.yaml"` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the application (used for Cloud Run, Subscription, and BigQuery dataset) | `string` | `"jwks-catalog-crawler"` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The GCP project id | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The GCP region to deploy resources to | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
