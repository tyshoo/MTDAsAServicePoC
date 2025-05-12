# MTDAsAServicePoC

Repo layout:
MTDAsAServicePoC/  
├── modules/  
&nbsp;│&nbsp;&nbsp;&nbsp;└── agent_mgmt/  
&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;├── main.tf  
&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;├── variables.tf  
&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;└── outputs.tf  
├── infra/  
&nbsp;│&nbsp;&nbsp;&nbsp;├── provider.tf  
&nbsp;│&nbsp;&nbsp;&nbsp;├── backend.tf  
&nbsp;│&nbsp;&nbsp;&nbsp;└── main.tf          ← calls module.agent_mgmt (and others)  
└── .github/  
 &nbsp;&nbsp;&nbsp;└── workflows/  
 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;└── ci.yml  
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
