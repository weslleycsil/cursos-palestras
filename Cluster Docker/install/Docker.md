Instalação do Docker no Centos 7
=============

Documento com o passo a passo para a instalação, configuração e utilização de um Cluster Docker com Swarm.

- [Configurações Básicas do Servidor](#configurações-básicas)
- [Instalar e Configurar o Docker](#instalação-do-docker)
- [Configurar Manager Docker]()
- [Configurar Node Docker]()

Configurações Básicas
=============

## Verificar as configurações de Rede

Duas interfaces, a principal é a eth0 e a secundáriae é a ens19. Um ponto importante, normalmente acontece do sistema deixar uma desativada por padrão no boot, ou seja, você pode até ativar manualmente, mas caso seja feito isso, você sempre precisará subir ela. Para que isso não ocorra modifique a configuração para ela iniciar em tempo de boot.

> ETH0 é a interface principal, ou seja, ela receberá um IP válido (para acessarmos de fora, diferentemente do secundário), seguirá no nosso caso com DHCP.
> ENS19 é a interface secundária, nela iremos configurar manualmente um endereço ip sem gateway e desmarcando ela como interface principal (DEFROUTE=no).

arquivo /etc/sysconfig/network-scripts/ifcfg-eth0
```
TYPE="Ethernet"
PROXY_METHOD="none"
BROWSER_ONLY="no"
BOOTPROTO="dhcp"
DEFROUTE="yes"
IPV4_FAILURE_FATAL="no"
IPV6INIT="no"
IPV6_AUTOCONF="no"
IPV6_DEFROUTE="no
IPV6_FAILURE_FATAL="no"
IPV6_ADDR_GEN_MODE="stable-privacy"
NAME="eth0"
UUID="82a82c10-3c73-4a07-8c63-41a64196bccf"
DEVICE="eth0"
ONBOOT="yes"
```

arquivo /etc/sysconfig/network-scripts/ifcfg-ens19
```
TYPE=Ethernet
PROXY_METHOD=none
BROWSER_ONLY=no
BOOTPROTO=none
DEFROUTE=no
IPV4_FAILURE_FATAL=no
IPV6INIT=no
IPV6_AUTOCONF=no
IPV6_DEFROUTE=no
IPV6_FAILURE_FATAL=no
IPV6_ADDR_GEN_MODE=stable-privacy
NAME=ens19
DEVICE=ens19
ONBOOT=yes
IPADDR=10.10.10.x
PREFIX=24
IPV6_PRIVACY=no
```

>Uma observação válida é sobre o NM_Controlled, em algumas versão mais antigas da ISO centos 7 havia um bug no Network Manager, portanto era aconselhável a remoção dele, para isso basta seguir os passos abaixo:

```
systemctl stop NetworkManager && systemctl disable NetworkManager
systemctl enable network && systemctl restart network
```

Adicionando nos arquivos de configuração de interfaces (ifcfg-eth0 e ifcfg-ens19) a seguinte linha:

```
NM_CONTROLLED=no
```

Após as modificações do arquivo de rede, você deve reiniciar o serviço de rede ou o computador.
```
systemctl restart network
```

## Servidor NTP e Hora local

```
rm -rf /etc/localtime && \
ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime && \
echo "server a.ntp.br" > /etc/ntp.conf 
```

## Desativar IPv6

Em alguns testes EU tive alguns bugs com o IPv6 Ativado nos Hosts do Cluster Docker, porém não é um passo obrigatório.

Adicionar informações no arquivo /etc/default/grub

```
GRUB_TIMEOUT=5
GRUB_DEFAULT=saved
GRUB_DISABLE_SUBMENU=true
GRUB_TERMINAL_OUTPUT="console"
GRUB_CMDLINE_LINUX="ipv6.disable=1 crashkernel=auto rhgb quiet"
GRUB_DISABLE_RECOVERY="true"
```

Gerar uma nova configuração do Grub
```
grub2-mkconfig -o /boot/grub2/grub.cfg
```

Adicionar as linhas abaixo no arquivo /etc/sysctl.conf:
```
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
```

## Instalações e passos necessários antes do Docker

O comando abaixo instala o repositorio epel-release e atualiza o sistema. Após são feitas instalações básicas como wget, git, htop, *vim* (super importante não? xD) e algumas ferramentas que auxiliam na administração do servidor no futuro.

Também é instalado o rsyslog, por mais que esse tutorial não ensine configurar um serviço de rsyslog, mas quem sabe num futuro curso?

Outra instalação interessante é a do qemu-guest-agent, como estou rodando no proxmox essas máquinas, acho super válido instalar ele para o proxmox conseguir acesso à algumas informações do servidor.

```
yum install epel-release -y && yum update -y && yum install wget git vim htop curl net-tools nfs-utils traceroute tcpdump qemu-guest-agent rsyslog -y
```

Também é interessante fazer a instalação do zabbix agent, mas se você quiser pode pular essa parte.
```
rpm -Uvh https://repo.zabbix.com/zabbix/5.0/rhel/7/x86_64/zabbix-release-5.0-1.el7.noarch.rpm
yum clean all && yum install zabbix-agent
systemctl enable zabbix-agent && systemctl start zabbix-agent
```

É importante falar nesse ponto, que devemos definir o hostname do servidor, certo?
```
hostnamectl set-hostname nomedoservidor
```

Alguns desabilitam o firewall, e deixam todo o cuidado dele sob resposabilidade do docker
```
systemctl stop firewalld && systemctl disable firewalld
```

Instalação do Docker
-----------

```
wget -qO- https://get.docker.com/ | sh
```

```
COMPOSE_VERSION=`git ls-remote https://github.com/docker/compose | grep refs/tags | grep -oP "[v]?[0-9]+\.[0-9]+\.[0-9]+$" | tail -n 1`
```

```
sh -c "curl -L https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose"
```

```
chmod +x /usr/local/bin/docker-compose
```

```
sh -c "curl -L https://raw.githubusercontent.com/docker/compose/${COMPOSE_VERSION}/contrib/completion/bash/docker-compose > /etc/bash_completion.d/docker-compose"
```

```
systemctl enable docker && systemctl restart docker
```

Configuração do Docker Manager
-----------

Para configurar uma nova instância do Docker Swarm é bem dificil, basta executar o comando abaixo e usar a saida dele para ingressar os nós de computação (Workers) ao nó Manager.

```
docker swarm init --advertise-addr 10.10.10.1
```

Se você perdeu o token, basta executar o comando abaixo que o docker informa novamente o comando a ser utilizado.

```
docker swarm join-token worker
```

Configuração do Docker Node (Worker)
-----------

Com a saída do comando anterior (docker swarm init) você deve completar o abaixo com o token passado para poder ingressar os nós de computação no Docker Manager.

```
docker swarm join --token SWMTKN-1-5bfl24udz1jg58a1jnd15vbe6kvxdzky9cb1xhd7rdrmvr22cr-atqtky9bk3u7fycwx8v9xhj97 10.10.10.1:2377
```

Configurando o Recolhimento de Métricas do Docker
-----------

arquivo /etc/docker/daemon.json
```
{
  "metrics-addr" : "127.0.0.1:9323",
  "experimental" : true
}
```