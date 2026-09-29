# Agent instructions

## Stack
- Cloud: Azure. IaC: Terraform / Bicep. CI/CD: GitHub Actions.
- <!-- add languages, frameworks, test commands -->

## Environments
| Environment | Subscription | Agent may deploy? |
|---|---|---|
| dev  | <!-- sub name/id --> | yes |
| test | <!-- --> | ask first |
| prod | <!-- --> | **never**: humans only |

## Rules
- Run `az account show` and confirm the subscription before any `az` or `terraform apply`.
- Always `terraform plan` before `apply`; never `destroy` (the hook blocks it).
- Secrets go in Key Vault or env vars, never in code (the hook blocks it).
- Naming: `<app>-<env>-<region>-<resource>` e.g. `shop-dev-weu-kv`.
- Tag every resource with `owner`, `env`, `cost-center`.
- Write tests first where possible; run them before saying work is done.
