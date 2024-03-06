#!/bin/bash


# Diretório contendo os arquivos .iso
isos_dir="/srv/tftp/isos"

# Diretório para montar os arquivos .iso
mount_dir="/srv/tftp/imagens"

arquivo_iso=$1

if [ "${arquivo_iso}" == "" ]; then
   echo ""
   echo " ?? ERRO: faltou informar qual a iso a ser montada" 
   echo "    USO : $0 /dir/exemplo.iso" 
   echo ""
   exit
fi

if [ ! -f ${arquivo_iso} ]; then
   echo "-- Iso inexistente: ${iso}"
   exit
fi

nome_arquivo=$(basename "$arquivo_iso" .iso)

# Diretório de montagem para cada arquivo .iso
diretorio_montagem="$mount_dir/$nome_arquivo"

mountp=$(grep -E "^${arquivo_iso}" /etc/fstab | cut -d' ' -f2)
if [ "$mountp" = "" ]; then
    #echo "Adicionando entrada no /etc/fstab"
    echo "$arquivo_iso $diretorio_montagem udf,iso9660 user,ro,loop 0 0" | tee -a /etc/fstab
fi

if ! grep -q -E "^$diretorio_montagem" /etc/exports; then
    #adiciono a entrada no /etc/exports
    echo "$diretorio_montagem 10.20.1.0/24(ro,sync,no_wdelay,insecure_locks,insecure,no_root_squash,no_subtree_check)" >> /etc/exports
fi

# Cria o diretório de montagem, se não existir
mkdir -p "$diretorio_montagem"

# Monta o arquivo .iso no diretório de montagem
mount "$diretorio_montagem"
exportfs 10.20.1.0/24:$diretorio_montagem

echo "Arquivo $nome_arquivo montado em $diretorio_montagem"

echo "Montagem concluída."