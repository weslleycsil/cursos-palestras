Instalação do Servidor NFS no Centos 7
=============

Documento com o passo a passo para a instalação, configuração e utilização de um serviço NFS rodando sob Centos 7 para utilização em um Cluster Docker Swarm (podendo ser utilizado também para outros fins).

- [Configurações Básicas do Servidor](#configurações-básicas)
- [Preparar os Discos com LVM](#volumes-lvm)
- [Montar os Volumes e configura no FSTAB](#montar-os-volumes-no-sistema)
- [Instalar e Configurar o Serviço NFS](#instalação)
- [Estender discos em caso de pouco espaço livre](#estender-volumes-lvm)

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

Volumes LVM
-----------

Basicamente iremos trabalhar com discos com LVM em um virtual group para podermos adicionar novos discos conforme a demanda por espaço for aumentando.

Listar Unidades
```
fdisk -l
```

Selecionar a unidade para trabalhar e efetuar os seguintes passos:
```
fdisk /dev/sdb
o
n
p
t
8e
w
```

Após, criar o pv e depois o vg
```
pvcreate /dev/sdb1
vgcreate HDD /dev/sdb1
```

Criar o Lv group, formatar os "discos"
```
lvcreate --name HDD_VOL --size 30G HDD
mkfs.ext4 /dev/HDD/HDD_VOL
```

## Montar os volumes no sistema

Criar a pasta em que irão ser montados os volumes.
```
mkdir -p /NFS_VOL/HDD
```

Obter o UUID do disco virtual e adicionar no FSTAB.
```
blkid /dev/HDD/HDD_VOL
```

(adicionar o uuid do disco no respectivo campo)
arquivo /etc/fstab
```
UUID=0ffc8c8c-c689-4179-8b63-a46b4931a204 /NFS_VOL/HDD               ext4    defaults 0       1
```

Instalação
-----------

```
yum install nfs-utils -y
systemctl start nfs-server && systemctl enable nfs-server
```

Configuração do Serviço NFS
-----------

Configuração básica do serviço:

arquivo /etc/sysconfig/nfs
```
RPCNFSDCOUNT=64
RPCNFSDARGS="-N 2 -N 3 -U" //apenas v4
```

Sempre que se for criar um novo compartilhamento para uma determinada aplição, basta fazer a adição da pasta no caminho /etc/exports conforme o modelo abaixo:

```
/NFS_VOL/HDD/live 10.10.10.0/24(rw,sync,no_root_squash,no_subtree_check)
```

Onde a primeira parte do comando se refere à pasta do volume a ser compartilhado, a segunda o endereço IP da rede a ser compartilhado (você pode liberar para um unico endereço ou uma rede), a terceira parte diz respeito às configurações do volume como permissão de leitura/escrita e outros parâmetros.

após basta executar o comando abaixo para iniciar o compartilhamento.
```
exportfs -a
```

Há um script na pasta scripts chamado new_nfs.sh que pode ser executado para a criação automática. [Script](https://github.com/weslleycsil/cursos-palestras/blob/master/Cluster%20Docker/scripts/new_nfs.sh)

Para verificar os compartilhamentos ativos de um servidor basta utilizar:
```
showmount -e 127.0.0.1
```


Estender Volumes LVM
-----------

Em dados momentos, será necessário aumentar a capacidade do seu servidor, para isso basta seguir os passos para criar um volume e adicionar aos volumes já criados.


VG Display para visualizar os virtual groups disponiveis. Após isso, basta adicionar ao virtual group o disco, estender o volume, e verificar a integridade do mesmo.

(passos do fdisk, criar um pv do novo disco somente após executar os passos abaixo, não é preciso criar um novo VG pois já existe!)

```
vgdisplay

vgextend HDD /dev/sdd1
lvextend -L +114GB /dev/HDD/HDD_VOL
e2fsck -f /dev/HDD/HDD_VOL
resize2fs -p /dev/HDD/HDD_VOL
e2fsck -f /dev/HDD/HDD_VOL
```

Links Úteis para Consulta
-----------
[Extend an Reduce LVMs in linux](https://www.tecmint.com/extend-and-reduce-lvms-in-linux/)
[Viva o Linux VLM](https://www.vivaolinux.com.br/dica/LVM-Logical-Volume-Manager)
[Entendendo LVM](https://www.vivaolinux.com.br/artigo/Entendendo-e-configurando-o-LVM-manualmente?pagina=4)
[LVM Dicas Rapidas](http://gutocarvalho.net/octopress/2013/05/17/lvm-dicas-rapidas/)