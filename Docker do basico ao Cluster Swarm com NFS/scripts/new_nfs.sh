#!/bin/bash
echo "Insira o nome do Volume a ser criado:"
read nome;

#Volume a ser criado no hdd
vol=/NFS_VOL/HDD/$nome
mkdir $vol
texto="10.10.10.0/24(rw,sync,no_root_squash,no_subtree_check)";
echo $vol $texto >> /etc/exports
exportfs -a
systemctl restart nfs-server
echo "Volume Criado no HDD"
echo "Finalizada a Criacao"
#du.sh
echo 'echo "---"' >> du.sh
echo 'echo "---' $nome '--"' >> du.sh
echo "du -sh /NFS_VOL/HDD/"$nome >> du.sh
echo "Finalizada a adicao no Sscript du.sh"