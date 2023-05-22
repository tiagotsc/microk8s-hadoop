####### SCRIPT USADO NO CENTOS 7 #######

# Atualize os pacotes e limpe o cache
sudo yum update -y && yum clean all

# Desativando firewall
sudo systemctl stop firewalld
sudo systemctl disable firewalld
sudo systemctl mask --now firewalld

# Desativando Selinux
sudo sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
sudo setenforce 0

# Gerenciador de portas
yum install lsof -y

# Usado pelo DNS MicroK8S
sudo yum -y install bind-utils

# Instalação biblioteca GCC 9 (possuí dependências utilizadas pelo MicroK8S)
sudo yum install centos-release-scl -y
sudo yum clean all
sudo yum install devtoolset-9-* -y
#scl enable devtoolset-9 bash
# Habilite apenas para usuário vagrant
sudo echo "source /opt/rh/devtoolset-9/enable" >> /home/vagrant/.bashrc
source /home/vagrant/.bashrc
# Habilita para todo o SO, apenas root tem permissão para alteração
#echo "source /opt/rh/devtoolset-9/enable" >> /etc/bashrc

#### Instalação MicroK8S no CentOS 7 ####

# Instala o repositório de pacotes extras
sudo yum -y install epel-release

# Instala o gerenciador de pacotes Snap
sudo yum -y install snapd

# Ativa o start nas reinicializações do SO
sudo systemctl enable snapd

# Inicia o gereciador de pacotes
sudo systemctl start snapd

# Crie um atalho para ser reconhecido com o nome snap
sudo ln -s /var/lib/snapd/snap /snap

# Instala o MicroK8S
sudo snap install microk8s --classic --channel=1.24/stable

# Adicione o usuário ao grupo microk8s
sudo usermod -a -G microk8s vagrant

# Crie o diretório e mude o proprietório
mkdir /home/vagrant/.kube
sudo chown -f -R vagrant:vagrant /home/vagrant/.kube

# Muda temporáriamente o grupo do usuário para não ter necessidade de reiniciar o SO
newgrp microk8s

# Crie apelido para kubectl
echo "alias kubectl='microk8s.kubectl'" >> /home/vagrant/.bashrc

# Habilita o gerenciamento e controle de DNS (Recomendado)
# microk8s enable dns

# Habilita load balance: É preciso definir um range de IP reservado para ele
# microk8s enable metallb:192.168.56.200-192.168.56.220

# Habilita o controlador de entrada
# microk8s enable ingress

# Habilita o gerenciamento de armazenamento
# microk8s enable hostpath-storage

# Habilita acesso ao serviços que rodam no host
# microk8s enable host-access

# Inicia o cluster MicroK8S
#microk8s start

# Para o cluster MicroK8S
#microk8s stop