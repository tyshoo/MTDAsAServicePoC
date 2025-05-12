module "agent_mgmt" {
  source            = "../modules/agent_mgmt"
  environment       = var.environment
  agent_bucket_name = var.agent_bucket_name   # USER INPUT: define this in infra/variables.tf
}

module "ingestion" {
  source             = "../modules/ingestion"
  environment        = var.environment
  lambda_function_name = var.lambda_function_name   # from infra/variables.tf
  api_name           = var.api_name                 # from infra/variables.tf
  stage_name         = var.stage_name               # typically "poc"
}
