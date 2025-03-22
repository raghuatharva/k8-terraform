#!/bin/bash

USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

ARCH="amd64"
PLATFORM=$(uname -s)_$ARCH

VALIDATE(){
   if [ $1 -ne 0 ]
   then
        echo -e "$2...$R FAILURE $N"
        exit 1
    else
        echo -e "$2...$G SUCCESS $N"
    fi
}

if [ $USERID -ne 0 ]
then
    echo "Please run this script with root access."
    exit 1 # manually exit if error comes.
else
    echo "You are super user."
fi

# docker
yum install -y yum-utils git
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
systemctl start docker
systemctl enable docker
usermod -aG docker ec2-user
VALIDATE $? "Docker installation"

# eksctl
curl -sL -A "Mozilla/5.0" -o eksctl_Linux_${ARCH}.tar.gz "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_Linux_${ARCH}.tar.gz"
# Verify that the downloaded file is indeed a gzip file
file eksctl_Linux_${ARCH}.tar.gz
tar -xzf eksctl_Linux_${ARCH}.tar.gz -C /tmp && rm eksctl_Linux_${ARCH}.tar.gz
chmod +x /tmp/eksctl
mv /tmp/eksctl /usr/local/bin/eksctl
/usr/local/bin/eksctl version
VALIDATE $? "eksctl installation"


# kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x ./kubectl
chown root:root /usr/local/bin/kubectl
mv kubectl /usr/local/bin/kubectl
VALIDATE $? "kubectl installation"

# # kubens
git clone https://github.com/ahmetb/kubectx /opt/kubectx
ln -s /opt/kubectx/kubens /usr/local/bin/kubens
VALIDATE $? "kubens installation"


# Helm
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
export PATH=$PATH:/usr/local/bin
source ~/.bashrc 
VALIDATE $? "helm installation"

#k9s
curl -sS https://webinstall.dev/k9s | bash
VALIDATE $? "k9s installation"

#ebs-csi-driver
kubectl apply -k "github.com/kubernetes-sigs/aws-ebs-csi-driver/deploy/kubernetes/overlays/stable/?ref=release-1.40"
VALIDATE $? "ebs drivers installation"

#efs-csi-driver
kubectl kustomize \
    "github.com/kubernetes-sigs/aws-efs-csi-driver/deploy/kubernetes/overlays/stable/ecr/?ref=release-2.1" > private-ecr-driver.yaml
kubectl apply -f private-ecr-driver.yaml 
VALIDATE $? "EFS CSI driver installation"

