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