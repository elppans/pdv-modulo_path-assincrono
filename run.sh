#!/bin/bash

# 1. Atualizar moduloPHPPDV Ubuntu 22.04:

rm -rf /tmp/atualizamodulo.tar.gz &>> /dev/null
tar -zxvf atualizamodulo_u22-2_14_166_144d_24291_php_8_1.tar.gz -C /tmp
cd /tmp/atualizamodulo
bash atualizamodulo.sh

# 2. Desativar path_comum assincrono

umount /Zanthus/Zeus/path_comum_servidor
systemctl disable path_comum_sinc.service 2>>/dev/null
mv /opt/webadmin/extra/path_comum_sinc /opt/webadmin/extra/path_comum_sinc.old
mkdir -p /Zanthus/Zeus/path_backup
mv /Zanthus/Zeus/path_comum /Zanthus/Zeus/path_backup
mv /Zanthus/Zeus/path_comum_temp /Zanthus/Zeus/path_backup
mv /Zanthus/Zeus/path_comum_servidor /Zanthus/Zeus/path_backup
mkdir -p /Zanthus/Zeus/path_comum

cp -av /etc/environment /etc/environment.backup_"$(date +%d%m%Y)"
sed -i '/Z_MOUNT/d' /etc/environment
