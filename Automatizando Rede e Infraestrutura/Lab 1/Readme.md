# Laboratório 1

Objetivos:
Configurar um ambiente com 4 Roteadores e 2 Switchs. Sendo um roteador (R1) já previamente configurado. A configuração se dará pelo processo de autoinstall da cisco.


Figura da Topologia

R1
DHCP Server na vlan1 -> 10.20.1.0/24
apontamento do tftp server
Vlan 10 -> 10.20.10.0/30
vlan 20 -> 10.20.20.0/30
vlan 30 -> 10.20.30.0/30
vlan 100 (gerenciamento) -> 10.20.100.0/24

Gi0/0 - Gi0/0 SW1
[Configuração do R1]()

R2
Gi0/0 - Gi0/1 SW1
[Configuração do R2]()

R3
Gi0/0 - Gi0/2 SW1
[Configuração do R3]()

R4
Gi0/0 - Gi0/0 SW2
[Configuração do R4]()

SW1
Gi0/0 - Gi0/0 R1
Gi0/1 - Gi0/0 R2
Gi0/2 - Gi0/0 R3
Gi1/3 - Gi1/3 SW2
[Configuração do SW1]()

SW2
Gi0/0 - Gi0/0 R4
Gi1/3 - Gi1/3 SW1
[Configuração do SW2]()

TFTP
eth0 - Gi1/2 SW1
[Configuração Servidor]()




Material Base Cisco Autoinstall
https://www.cisco.com/c/en/us/td/docs/ios-xml/ios/fundamentals/configuration/15mt/fundamentals-15-mt-book/cf-autoinstall.html
https://packetpushers.net/blog/freeztp/
https://github.com/PackeTsar/freeztp/tree/latest


Repositórios de ZTP (zero touch provisioning)
https://github.com/jeremycohoe/IOSXE-Zero-Touch-Provisioning
https://github.com/cisco-ie/IOSXE_ZTP
https://github.com/tdorssers/ztp
