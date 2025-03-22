terraform {
  required_providers {
    aws = {                     #provider name      
      source  = "hashicorp/aws" #source of provider
      version = "5.84.0"        #version of provider
    }
  }
  backend "s3" { #backend info should always be in terraform block
    bucket         = "remotestate11"
    key            = "expense_k8_sg_module/terraform.tfstate"
    region         = "us-east-1" # region of bucket and dynamodb
    dynamodb_table = "raghu"     #partition key should always be LockID --> case sensitive
  }
}

# here we configure AWS provider
provider "aws" {
  #configuration options
  region = "us-east-1"
}

