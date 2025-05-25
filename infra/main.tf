module "agent_mgmt" {
  source            = "../modules/agent_mgmt"
  environment       = var.environment
  agent_bucket_name = var.agent_bucket_name
  common_tags       = module.tags.common_tags
}

module "ingestion" {
  source              = "../modules/ingestion"
  environment         = var.environment
  common_tags         = module.tags.common_tags
  lambda_function_name = var.lambda_function_name
  api_name            = var.api_name
  stage_name          = var.stage_name
  vpc_id              = module.network.vpc_id             # from network module
  private_subnet_ids  = module.network.private_subnets    # from network module
  web_acl_arn         = module.network.waf_web_acl_arn    # from network module (optional)
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
