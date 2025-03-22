data "aws_ssm_parameter" "vpc" {
  name = "/${var.project}/${var.environment}/vpc_id"
}