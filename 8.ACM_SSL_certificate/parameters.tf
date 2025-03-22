resource "aws_ssm_parameter" "certificate_arn" {
  name = "/${var.project}/${var.environment}/https_certificate_arn"
  type = "String"
  value = aws_acm_certificate.https.arn
}





