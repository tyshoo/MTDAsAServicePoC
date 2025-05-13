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

module "dashboards_siem" {
  source              = "../modules/dashboards_siem"
  environment         = var.environment
  dashboard_name      = var.dashboard_name
  lambda_function_name = module.ingestion.lambda_function_name
}

module "security_guardrails" {
  source          = "../modules/security_guardrails"
  environment     = var.environment
  config_rule_name = var.config_rule_name       # from infra/variables.tf
  cloudtrail_name  = var.cloudtrail_name        # from infra/variables.tf
}

#tags
module "tags" {
  source      = "../modules/tags"
  environment = var.environment      # e.g. "poc"
  project     = "mtd-edr"
  owner       = "SecOpsTeam"
  cost_center = "CC1234"
}
