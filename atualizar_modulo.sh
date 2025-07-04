#!/bin/bash

# 1. Atualizar moduloPHPPDV Ubuntu 22.04:

# rm -rf /tmp/atualizamodulo.tar.gz &>> /dev/null
# tar -zxvf atualizamodulo_u22-2_14_166_144d_24291_php_8_1.tar.gz -C /tmp
cd atualizamodulo
bash atualizamodulo.sh
