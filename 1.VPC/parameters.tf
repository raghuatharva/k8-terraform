resource "aws_ssm_parameter" "vpc" {
  name  = "/${var.project}/${var.environment}/vpc_id"
  type  = "String"
  value = module.vpc.vpc #last .vpc is the output name name of the root module
}

resource "aws_ssm_parameter" "public_subnet_ids" {
  name  = "/${var.project}/${var.environment}/public_subnet_ids"
  type  = "StringList" #
  value = join(",", module.vpc.public_subnet_ids)
}

#StringList is used to store multiple values ["aaaa,baaaa,caaa"] , our list will be ["aaaa","baaa","caaa"] ,
# so use join function to make a stringlist

resource "aws_ssm_parameter" "private_subnet_ids" {
  name  = "/${var.project}/${var.environment}/private_subnet_ids"
  type  = "StringList"
  value = join(",", module.vpc.private_subnet_ids)
}

resource "aws_ssm_parameter" "mysql_subnet_ids" {
  name  = "/${var.project}/${var.environment}/mysql_subnet_ids"
  type  = "StringList"
  value = join(",", module.vpc.mysql_subnet_ids)
}

resource "aws_ssm_parameter" "database_subnet_group" {
  name  = "/${var.project}/${var.environment}/database_subnet_group"
  type  = "String"
  value = module.vpc.database_subnet_group
}