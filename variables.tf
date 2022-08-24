variable "name" {
  type    = string
  default = ""
}

variable "lambdas_tracing_mode" {
  type    = string
  default = "PassThrough"
}

variable "brands_write_rds_staging_env" {
  type    = map(any)
  default = {}
}

variable "runtime_nodejs" {
  type    = string
  default = "nodejs14.x"
}

variable "s3_artifacts_bucket" {
  type    = string
  default = "pmlo-deployment-artifacts"
}

variable "tags" {
  type    = map(any)
  default = {}
}

variable "lambdas_brands_write_rds_staging_zip" {
  type    = string
  default = ""
}

variable "datadog_layer_arn" {
  type    = string
  default = ""
}

variable "vpc_subnet_ids" {
  type    = string
  default = ""
}

variable "vpc_security_group_ids" {
  type    = string
  default = ""
}

variable "slack_notify_topic_staging_arn" {
  type    = string
  default = ""
}

variable "lambdas_brands_write_rds_staging_version" {
  type    = string
  default = ""
}