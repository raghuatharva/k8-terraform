
resource "aws_ssm_parameter" "web_alb_sg_id" {
  # /expense/dev/mysql_sg_id
  name  = "/${var.project}/${var.environment}/web_alb_sg_id"
  type  = "String"
  value = module.web_alb_sg.id
}

resource "aws_ssm_parameter" "eks_control_plane_sg_id" {
  # /expense/dev/mysql_sg_id
  name  = "/${var.project}/${var.environment}/eks_control_plane_sg_id"
  type  = "String"
  value = module.eks_control_plane_sg.id
}


resource "aws_ssm_parameter" "node_sg_id" {
  # /expense/dev/mysql_sg_id
  name  = "/${var.project}/${var.environment}/node_sg_id"
  type  = "String"
  value = module.node_sg.id
}


resource "aws_ssm_parameter" "mysql_sg_id" {
  # /expense/dev/mysql_sg_id
  name  = "/${var.project}/${var.environment}/mysql_sg_id"
  type  = "String"
  value = module.mysql_sg.id
}

# resource "aws_ssm_parameter" "vpn_sg_id" {
#   # /expense/dev/mysql_sg_id
#   name  = "/${var.project}/${var.environment}/vpn_sg_id"
#   type  = "String"
#   value = module.vpn_sg.id
# }

resource "aws_ssm_parameter" "bastion_sg_id" {
  # /expense/dev/mysql_sg_id
  name  = "/${var.project}/${var.environment}/bastion_sg_id"
  type  = "String"
  value = module.bastion_sg.id
}

