module "bastion" {
  source = "terraform-aws-modules/ec2-instance/aws"

  ami                    = local.ami
  instance_type          = "t2.micro"
  subnet_id              = local.public_subnet_id
  vpc_security_group_ids = [local.bastion_sg] #always a list
  name                   = local.resource_name
  user_data              = file("workstation.sh")

  tags = { #here tags is not an argument , its a variable 
    Terraform   = "true"
    Environment = "dev"
  }
}
    