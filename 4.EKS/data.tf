data "aws_ssm_parameter" "eks_control_plane_sg_id" {
  #/expense/dev/bastion_sg_id
  name = "/${var.project_name}/${var.environment}/eks_control_plane_sg_id"
}

data "aws_ssm_parameter" "node_sg_id" {
  #/expense/dev/bastion_sg_id
  name = "/${var.project_name}/${var.environment}/node_sg_id"
}

data "aws_ssm_parameter" "private_subnet_ids" {
  #/expense/dev/public_subnet_ids
  name = "/${var.project_name}/${var.environment}/private_subnet_ids"
}

data "aws_ssm_parameter" "vpc_id" {
  name = "/${var.project_name}/${var.environment}/vpc_id"
}