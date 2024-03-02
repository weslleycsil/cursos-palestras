#!/bin/bash


# script para compilar o ipxe
# Autor: Weslley Silva
# Data: 30/01/2024
# Versão: 1.0

#clonar o repositório do ipxe
git clone git://git.ipxe.org/ipxe.git /ipxe
cd /ipxe/src


# ativar suporte ao NFS
sed -i 's/#undef\tDOWNLOAD_PROTO_NFS/#define\tDOWNLOAD_PROTO_NFS/' config/general.h

# ativar suporte ao HTTP
sed -i 's/#undef\tDOWNLOAD_PROTO_HTTP/#define\tDOWNLOAD_PROTO_HTTP/' config/general.h

# ativar suporte ao HTTPS
#sed -i 's/#undef\tDOWNLOAD_PROTO_HTTPS/#define\tDOWNLOAD_PROTO_HTTPS/' config/general.h

# criar o arquivo embed.ipxe conteudo 

echo "#!ipxe
  
dhcp
chain tftp://10.20.1.1/ipxe/menu/menu.ipxe || shell" > /ipxe/src/embed.ipxe

# fazer o build dos binários necessários
make bin/undionly.kpxe EMBED=embed.ipxe
make bin-x86_64-efi/ipxe.efi EMBED=embed.ipxe

#make bin/undionly.kpxe EMBED=embed.ipxe CERT=/opt/src/certs/RooT.crt,/opt/src/certs/ICPEdu.crt,/opt/src/certs/_.setic.ufsc.br.crt TRUST=/opt/src/certs/RooT.crt,/opt/src/certs/ICPEdu.crt,/opt/src/certs/_.setic.ufsc.br.crt
#make bin-x86_64-efi/ipxe.efi EMBED=embed.ipxe CERT=/opt/src/certs/RooT.crt,/opt/src/certs/ICPEdu.crt,/opt/src/certs/_.setic.ufsc.br.crt TRUST=/opt/src/certs/RooT.crt,/opt/src/certs/ICPEdu.crt,/opt/src/certs/_.setic.ufsc.br.crt

cp bin/undionly.kpxe /opt/src/binarios/
cp bin-x86_64-efi/ipxe.efi /opt/src/binarios/
