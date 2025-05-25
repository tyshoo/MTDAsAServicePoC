
# Deploy
```
git clone https://github.com/tyshoo/MTDAsAServicePoC
cd infra
terraform init
terraform apply -auto-approve
```
Validate: 
```
cd infra && terraform init && terraform apply
```
should create an S3 bucket and the placeholder object.


## WIP Enhancements
1. Module Tagging Hook:
```
module "common_tags" { … }
locals { tags = module.common_tags.tags }  
resource "aws_s3_bucket" "agent" { tags = local.tags }
```
2. Terraform Workspace Strategy:
One workspace per env (```poc, dev, staging, prod```)
Guard workspace drift with CI gating

3. Basic Canary & Feature Flag Stub:
Stub a feature-flag Lambda layer or Parameter Store key so Phase 2 can toggle Kinesis on/off without code changes.

4. Automated Alarms:
```resource "aws_cloudwatch_metric_alarm" "lambda_error" { … }```
– Trigger on >1 Error/minute, alert via SNS.
5. API Gateway WAF ACL (PoC Stub):
Provision a WAF WebACL (even with default rules) and attach to the PoC API.

6. Infra Tests:
Add a simple test that ```“terraform apply”``` yields 5 resources, all passing aws iam get-role and S3 bucket exists.

7. README & Diagrams:
One-page C4‐style diagram, module README explaining inputs/outputs, linking up to the 19‐pillar view.
