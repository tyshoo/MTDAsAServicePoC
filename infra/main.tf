module "agent_mgmt" {
  source            = "../modules/agent_mgmt"
  environment       = var.environment
  agent_bucket_name = var.agent_bucket_name   # USER INPUT: define this in infra/variables.tf
}
