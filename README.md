# MTDAsAServicePoC

Repo layout:
MTDAsAServicePoC/  
> ── modules/  
>>   └── agent_mgmt/  
>>>       ├── main.tf  
>>>       ├── variables.tf  
>>>       └── outputs.tf  
> ── infra/  
>>   ├── provider.tf  
>>   ├── backend.tf
>>   └── main.tf          ← calls module.agent_mgmt (and others)

> ── .github/  
>>   └── workflows/  
>>>      └── ci.yml  
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
