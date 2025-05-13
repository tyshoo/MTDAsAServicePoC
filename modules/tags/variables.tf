variable "environment" {
  description = "Deployment environment (e.g. poc, dev, prod)"
  type        = string
}

variable "project" {
  description = "Project name"
  type        = string
}

variable "owner" {
  description = "Team or individual responsible"
  type        = string
}

variable "cost_center" {
  description = "Cost center or billing code"
  type        = string
}
