data "aws_ssm_parameter" "vpc" {
  name = "/${var.project}/${var.environment}/vpc_id"
}

data "aws_ssm_parameter" "web_alb_sg_id" {
  name = "/${var.project}/${var.environment}/web_alb_sg_id"
}

data "aws_ssm_parameter" "public_subnet_id" {
  name = "/${var.project}/${var.environment}/public_subnet_ids"
}

data "aws_ssm_parameter" "certificate_arn" {
  name = "/${var.project}/${var.environment}/https_certificate_arn"
}

# data "aws_ssm_parameter" "frontend_target_group" {
#   name = "/${var.project}/${var.environment}/frontend_target_group"
# }
