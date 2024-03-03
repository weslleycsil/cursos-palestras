# Configuração do Servidor 1

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

Após o serviço de TFTP estar ativo, precisamos configurar o ip fixo na interface de rede do servidor.
Para isso, iremos configurar essas informações no Netplan.

Arquivo /etc/netplan/00-installer-config.yaml

```
network:
    ethernets:
        ens3:
            dhcp4: no
            addresses: [10.20.1.1/24]
            routes:
                - to: default
                  via: 10.20.1.1
            nameservers:
                addresses: [1.1.1.1,8.8.8.8]
```

Para aplicar as configurações acima, basta executar:

```
sudo netplan apply
```     

Após isso tudo, basta apenas adicionar os arquivos na raiz do TFTP.
```
network-confg
r2-confg
r3-confg
r4-confg
```

Agora é ser feliz!