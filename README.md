# terraform-gcp-filestore

[![Build Status](https://github.com/JamesWoolfenden/terraform-gcp-filestore/workflows/Verify/badge.svg?branch=main)](https://github.com/JamesWoolfenden/terraform-gcp-filestore)
[![Latest Release](https://img.shields.io/github/release/JamesWoolfenden/terraform-gcp-filestore.svg)](https://github.com/JamesWoolfenden/terraform-gcp-filestore/releases/latest)
[![GitHub tag (latest SemVer)](https://img.shields.io/github/tag/JamesWoolfenden/terraform-gcp-filestore.svg?label=latest)](https://github.com/JamesWoolfenden/terraform-gcp-filestore/releases/latest)
![Terraform Version](https://img.shields.io/badge/tf-%3E%3D1.5.0-blue.svg)
[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white)](https://github.com/pre-commit/pre-commit)
[![checkov](https://img.shields.io/badge/checkov-verified-brightgreen)](https://www.checkov.io/)

Terraform module for Filestore. Exercises holden's `policies/gcp/filestore` policy set.

## Usage

Add **module.filestore.tf** to your code:-

```terraform
module "filestore" {
  source       = "JamesWoolfenden/filestore/gcp"
  version      = "0.0.1"
  kms_key_name = google_kms_crypto_key.filestore.id
  network_id   = google_compute_network.filestore.id
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_google"></a> [google](#provider\_google) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [google_filestore_instance.main](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/filestore_instance) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_capacity_gb"></a> [capacity\_gb](#input\_capacity\_gb) | Capacity of the file share, in GiB | `number` | `1024` | no |
| <a name="input_connect_mode"></a> [connect\_mode](#input\_connect\_mode) | Network connection mode used by the instance | `string` | `"DIRECT_PEERING"` | no |
| <a name="input_deletion_protection_enabled"></a> [deletion\_protection\_enabled](#input\_deletion\_protection\_enabled) | Whether deletion protection is enabled for the Filestore instance | `bool` | `true` | no |
| <a name="input_deletion_protection_reason"></a> [deletion\_protection\_reason](#input\_deletion\_protection\_reason) | Reason for enabling/disabling deletion protection, surfaced in the GCP console | `string` | `null` | no |
| <a name="input_description"></a> [description](#input\_description) | Description of the Filestore instance | `string` | `null` | no |
| <a name="input_file_share_name"></a> [file\_share\_name](#input\_file\_share\_name) | Name of the NFS file share exposed by the instance | `string` | `"share1"` | no |
| <a name="input_kms_key_name"></a> [kms\_key\_name](#input\_kms\_key\_name) | Resource name of the Cloud KMS key used to encrypt the Filestore instance | `string` | n/a | yes |
| <a name="input_labels"></a> [labels](#input\_labels) | Labels to apply to the Filestore instance | `map(string)` | `{}` | no |
| <a name="input_location"></a> [location](#input\_location) | Location of the Filestore instance | `string` | `"europe-west2-a"` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the Filestore instance | `string` | `"main"` | no |
| <a name="input_network_id"></a> [network\_id](#input\_network\_id) | Self link of the VPC network the Filestore instance attaches to | `string` | n/a | yes |
| <a name="input_network_modes"></a> [network\_modes](#input\_network\_modes) | IP versions for which the instance has IP addresses reserved | `list(string)` | <pre>[<br/>  "MODE_IPV4"<br/>]</pre> | no |
| <a name="input_nfs_export_options"></a> [nfs\_export\_options](#input\_nfs\_export\_options) | NFS export access control for the file share. Filestore applies its own default (full read/write access from the entire client network) when this is null; set it explicitly to restrict client IP ranges or access mode. | <pre>list(object({<br/>    ip_ranges   = optional(list(string))<br/>    access_mode = optional(string, "READ_WRITE")<br/>    squash_mode = optional(string, "NO_ROOT_SQUASH")<br/>    anon_uid    = optional(number)<br/>    anon_gid    = optional(number)<br/>  }))</pre> | `null` | no |
| <a name="input_performance_config"></a> [performance\_config](#input\_performance\_config) | IOPS-per-TB performance configuration for tiers that support it (e.g. ENTERPRISE, HIGH\_SCALE\_SSD) — IOPS scale with provisioned capacity. Leave null for tiers (e.g. BASIC\_HDD, BASIC\_SSD) that don't support it. Fixed (capacity-independent) IOPS is not exposed by this module to keep it to a single configuration path. | <pre>object({<br/>    max_iops_per_tb = number<br/>  })</pre> | `null` | no |
| <a name="input_protocol"></a> [protocol](#input\_protocol) | File system protocol of the instance | `string` | `"NFS_V3"` | no |
| <a name="input_reserved_ip_range"></a> [reserved\_ip\_range](#input\_reserved\_ip\_range) | CIDR range, or name of an allocated address range, used when connect\_mode is PRIVATE\_SERVICE\_ACCESS. Leave null for DIRECT\_PEERING. | `string` | `null` | no |
| <a name="input_tier"></a> [tier](#input\_tier) | Tier of the Filestore instance | `string` | `"BASIC_HDD"` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_instance"></a> [instance](#output\_instance) | The full Filestore instance resource |
| <a name="output_instance_id"></a> [instance\_id](#output\_instance\_id) | ID of the Filestore instance |
| <a name="output_ip_addresses"></a> [ip\_addresses](#output\_ip\_addresses) | IP addresses of the Filestore instance, for NFS mount targets |
| <a name="output_name"></a> [name](#output\_name) | Name of the Filestore instance |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

<!-- BEGINNING OF PRE-COMMIT-PIKE DOCS HOOK -->
The Terraform resource required is:

```golang

resource "google_project_iam_custom_role" "terraform_pike" {
  project     = "pike-477416"
  role_id     = "terraform_pike"
  title       = "terraform_pike"
  description = "A user with least privileges"
  permissions = [
    "file.instances.create",
    "file.instances.delete",
    "file.instances.get",
    "file.instances.update",
    "file.operations.get"
  ]
}


```
<!-- END OF PRE-COMMIT-PIKE DOCS HOOK -->

## Help

**Got a question?**

File a GitHub [issue](https://github.com/JamesWoolfenden/terraform-gcp-filestore/issues).

## Contributing

### Bug Reports & Feature Requests

Please use the [issue tracker](https://github.com/JamesWoolfenden/terraform-gcp-filestore/issues) to report any bugs or file feature requests.

## Copyrights

Copyright © 2026 James Woolfenden

## License

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

See [LICENSE](LICENSE) for full details.

Licensed to the Apache Software Foundation (ASF) under one
or more contributor license agreements. See the NOTICE file
distributed with this work for additional information
regarding copyright ownership. The ASF licenses this file
to you under the Apache License, Version 2.0 (the
"License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at

<https://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing,
software distributed under the License is distributed on an
"AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
KIND, either express or implied. See the License for the
specific language governing permissions and limitations
under the License.

### Contributors

[![James Woolfenden][jameswoolfenden_avatar]][jameswoolfenden_homepage]<br/>[James Woolfenden][jameswoolfenden_homepage]

[jameswoolfenden_homepage]: https://github.com/jameswoolfenden
[jameswoolfenden_avatar]: https://github.com/jameswoolfenden.png?size=150
