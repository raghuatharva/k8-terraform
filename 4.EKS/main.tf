##############################################
# To upgrade the eks cluster without downtime, below are the steps
# 1. create a green node group 
# 2.cordon the green node group
# 3. upgarde the cluster from console to the latest version
# 4. upgrade the green node group to the latest version 
# 5. uncordon the green node group
# 6. cordon the blue node group
# 7. drain the blue node group
# 8. once all the pods moves to green , delete the blue node group


resource "aws_key_pair" "eks" {
  key_name   = "openvpn_rsa"  #just using some key which i created earlier , vpn key ನೆ ಬೇಕಂತಿಲ್ಲ 
  public_key = file("/Users/apple/.ssh/openvpn_rsa.pub")
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"


  cluster_name    = "${var.project_name}-${var.environment}"
  cluster_version = "1.31" #while upgrading the nodegroup and cluster , make sure to upgrade this version

  cluster_endpoint_public_access  = true #if false we need vpn to access eks cluster 

  cluster_addons = {
    coredns                = {}
    eks-pod-identity-agent = {}
    kube-proxy             = {}
    vpc-cni                = {}
  }

  vpc_id                   = data.aws_ssm_parameter.vpc_id.value
  subnet_ids               = local.private_subnet_ids
  control_plane_subnet_ids = local.private_subnet_ids

  create_cluster_security_group = false
  cluster_security_group_id     = local.eks_control_plane_sg_id

  create_node_security_group = false
  node_security_group_id     = local.node_sg_id

  # the user which you used to create cluster will get admin access

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    instance_types = ["m6i.large", "m5.large", "m5n.large", "m5zn.large"]
  }

  eks_managed_node_groups = {
    blue = {
      min_size      = 2
      max_size      = 10
      desired_size  = 2
      capacity_type = "SPOT"
      iam_role_additional_policies = {
        AmazonEBSCSIDriverPolicy          = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
        AmazonElasticFileSystemFullAccess = "arn:aws:iam::aws:policy/service-role/AmazonElasticFileSystemFullAccess"
        ElasticLoadBalancingFullAccess = "arn:aws:iam::aws:policy/ElasticLoadBalancingFullAccess"
      }
      # EKS takes AWS Linux 2 as it's OS to the nodes
      key_name = aws_key_pair.eks.key_name
    }
    # green = {
    #   min_size      = 2
    #   max_size      = 10
    #   desired_size  = 2
    #   #capacity_type = "SPOT"
    #   iam_role_additional_policies = {
    #     AmazonEBSCSIDriverPolicy          = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
    #     AmazonElasticFileSystemFullAccess = "arn:aws:iam::aws:policy/AmazonElasticFileSystemFullAccess"
    #     ElasticLoadBalancingFullAccess = "arn:aws:iam::aws:policy/ElasticLoadBalancingFullAccess"
    #   }
      # EKS takes AWS Linux 2 as it's OS to the nodes
      # key_name = aws_key_pair.eks.key_name
    }
  

  # Cluster access entry
  # To add the current caller identity as an administrator
  enable_cluster_creator_admin_permissions = true

  tags = var.common_tags
}
