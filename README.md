
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
