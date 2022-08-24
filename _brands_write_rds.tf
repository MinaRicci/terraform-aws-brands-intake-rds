module "brands-write-rds-staging" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "3.3.1"

  function_name          = "brands-write-rds-staging-${var.name}"
  description            = "Sync marketplacer brands to ${var.name} instance"
  handler                = "src/index.handler"
  runtime                = var.runtime_nodejs
  memory_size            = 512
  timeout                = 10
  maximum_retry_attempts = 0

  s3_existing_package = {
    bucket = var.s3_artifacts_bucket
    key    = var.lambdas_brands_write_rds_staging_zip
  }

  layers = [
    var.datadog_layer_arn,
  ]

  publish                   = true
  create_package            = false
  create_async_event_config = true

  attach_cloudwatch_logs_policy = true
  attach_async_event_policy     = true
  attach_network_policy         = true

  vpc_subnet_ids         = var.vpc_subnet_ids
  vpc_security_group_ids = var.vpc_security_group_ids

  tracing_mode = var.lambdas_tracing_mode

  cloudwatch_logs_retention_in_days = 7

  destination_on_failure = var.slack_notify_topic_staging_arn

  environment_variables = var.brands_write_rds_staging_env

  allowed_triggers = {
    Cloudwatch = {
      principal  = "events.amazonaws.com"
      source_arn = aws_cloudwatch_event_rule.scheduler_brands_write_rds.arn
    }
  }

  tags = merge(local.staging_tags, {
    Name    = "brands-write-rds-staging-${var.name}",
    Service = "brands-pipeline"
    Version = var.lambdas_brands_write_rds_staging_version
    }, {
    git_commit           = "N/A"
    git_file             = "master/ap-southeast-1/_brands_write_rds.tf"
    git_last_modified_at = "2022-06-30 11:54:24"
    git_last_modified_by = "sven.l+github@pomelofashion.com"
    git_modifiers        = "51740341+nivincp/77258023+cloudboyd/98529991+myint2022/sven.l+github"
    git_org              = "pomelofashion"
    git_repo             = "infrastructure-lambda"
    yor_trace            = "59e3d7dd-c83f-4c65-8dfc-3ef78b851b09"
  })

  providers = {
    aws = aws.master
  }
}

resource "aws_cloudwatch_event_rule" "scheduler_brands_write_rds" {
  provider = aws.master

  name                = "scheduler_brands_write_rds_${var.name}"
  description         = "Every Hours At Minute 0"
  schedule_expression = "cron(0 * * * ? *)"

  tags = merge(local.staging_tags, {
    Name = "brands-write-rds-staging-${var.name}"
    }, {
    git_commit           = "N/A"
    git_file             = "master/ap-southeast-1/_brands_write_rds.tf"
    git_last_modified_at = "2022-06-30 11:54:24"
    git_last_modified_by = "sven.l+github@pomelofashion.com"
    git_modifiers        = "51740341+nivincp/sven.l+github"
    git_org              = "pomelofashion"
    git_repo             = "infrastructure-lambda"
    yor_trace            = "9ddaee34-e802-4413-a4b1-4a57c4e417ad"
  })
}

resource "aws_cloudwatch_event_target" "scheduler_brands_write_rds_staging" {
  provider = aws.master

  rule = aws_cloudwatch_event_rule.scheduler_brands_write_rds.id
  arn  = module.brands-write-rds-staging.lambda_function_arn
}
