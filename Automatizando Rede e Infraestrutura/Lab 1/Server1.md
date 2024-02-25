# Configuração do Servidor 1

## Instalação do Serviço TFTP

Precisamos dos pacotes referentes ao serviço de TFTP.

apt-get install tftpd-hpa
nano /etc/default/tftpd-hpa

TFTP_USERNAME="tftp"
TFTP_DIRECTORY="/var/lib/tftpboot"
TFTP_ADDRESS="0.0.0.0:69"
TFTP_OPTIONS="--secure --create"

mkdir /var/lib/tftpboot
sudo chown -R nobody:nogroup /var/lib/tftpboot
sudo chmod -R 777 /var/lib/tftpboot
sudo systemctl restart tftpd-hpa


Users da Imagem no EVE
user/Test123
root/Test123