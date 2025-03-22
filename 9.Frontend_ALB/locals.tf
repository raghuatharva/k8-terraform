locals {
    public_subnet_id = split(",", data.aws_ssm_parameter.public_subnet_id.value)
    vpc_id = data.aws_ssm_parameter.vpc.value
    web_alb_sg_id = data.aws_ssm_parameter.web_alb_sg_id.value
    certificate_arn = data.aws_ssm_parameter.certificate_arn.value
    # target_group_arn = data.aws_ssm_parameter.frontend_target_group.value
}