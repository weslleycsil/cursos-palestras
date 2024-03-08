# Servidor TFTP

O servidor está sendo baseado na imagem do Ubuntu 22.04 Server.
Users da Imagem no EVE
```
root/Test123
user/Test123
```

## Instalação do Serviço TFTP

Precisamos dos pacotes referentes ao serviço de TFTP.

```
sudo apt-get install tftpd-hpa
```

Arquivo /etc/default/tftpd-hpa

```
TFTP_USERNAME="tftp"
TFTP_DIRECTORY="/srv/tftp"
TFTP_ADDRESS=":69"
TFTP_OPTIONS="--secure"
```

Precisamos de um diretório para ser a raiz do TFTP, inicialmente no arquivo anterior colocamos: /srv/tftp 
Se não existir o diretório, basta criar:

```
sudo mkdir /srv/tftp
sudo chown -R nobody:nogroup /srv/tftp
sudo chmod -R 777 /srv/tftp
sudo systemctl restart tftpd-hpa
```

Após o serviço de TFTP estar ativo, precisamos configurar o ip fixo na interface de rede do servidor e também configurar a segunda interface como DHCP para que a mesma possa conectar à internet.
Para isso, iremos configurar essas informações no Netplan.

Arquivo /etc/netplan/00-installer-config.yaml

```
network:
    ethernets:
        ens3:
            dhcp4: no
            addresses: [10.20.1.1/24]
        ens4:
            dhcp4: true
```

Para aplicar as configurações acima, basta executar:

```
sudo netplan apply
```

Com a configuração do TFTP já feita, precisamos agora começar a configuração do iPXE.

## Configurando o iPXE

O iPXE é um projeto e você pode encontrar mais informações em: [ipxe.org](https://ipxe.org)

Aqui para facilitar, já deixei tudo mastigado e compilado para você no diretorio `compiler-ipxe`, inclusive lá tem um container onde você consegue fazer a compilação com os parametros que você necessitar para o seu ambiente, dê uma olhadinha, mas aqui não entraremos nesse assunto.

Dentro da pasta do TFTP crie uma estrutura para o ipxe, no meu caso criei o seguinte:

Diretório /srv/tft/

```
ipxe
\-- menu -> Onde irão ficar os arquivos do menu do ipxe
\-- isos -> onde ficarão arquivos do tipo iso para usar no menu
\-- imagens -> onde ficarão as imagens isos montadas para o NFS (falaremos mais depois)
\-- bin -> onde ficarão arquivos binarios do syslinux 5.10
```

## Instalação do NFS

Precisaremos fazer a instalação do NFS para podermos entregar certas imagens (linux) e também entregar de forma mais rapida isos e etc.

```
apt install nfs-kernel-server
```

## Download do Syslinux

Precisaremos do download do syslinux para podermos carregar isos diretamente no ipxe. Após o download, basta descompactar no diretório /srv/tft/bin/

```
wget https://mirrors.edge.kernel.org/pub/linux/utils/boot/syslinux/syslinux-5.10.zip
```

## Configuração do DHCP Server

Para entregarmos o DHCP nesse Lab, iremos utilizar o serviço no servidor Linux mesmo. Para isso, instalamos o pacote e faremos as configs necessárias como a seleção da interface que iremos utilizar para o serviço e também a configuração para entregar o filename para o computador buscar o arquivo do iPXE.

```
sudo apt install isc-dhcp-server
```

Selecionamos a interface que iremos utilizar no arquivo `/etc/default/isc-dhcp-server`

```
INTERFACESv4="ens3"
```

Adicionamos ao arquivo de configuração, as informações necessárias para o boot pxe funcionar corretamente no arquivo `/etc/dhcp/dhcpd.conf`

```
option client-arch code 93 = unsigned integer 16;
subnet 10.20.1.0 netmask 255.255.255.0 {
    range 10.20.1.100 10.20.1.199;
    option routers 10.20.1.1;
    option domain-name-servers 10.20.1.1;
    next-server 10.20.1.1;
    if exists user-class and option user-class = "iPXE" {
        filename "ipxe/menu/menu.ipxe";
    } elsif option client-arch != 0 {
        filename "ipxe/ipxe.efi";
    } else {
        filename "ipxe/undionly.kpxe";
    }
}
```

E por fim, reiniciamos o serviço do dhcp para que o mesmo inicie com as informações corretas.

```
sudo systemctl restart isc-dhcp-server.service
```