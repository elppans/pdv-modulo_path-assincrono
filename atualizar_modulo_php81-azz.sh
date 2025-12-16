#!/bin/bash

source /Zanthus/Zeus/pdvJava/ATUMDL.CFG
source /Zanthus/Zeus/pdvJava/ATUMDL_0.TXT

DOCMOD="$(docker ps | grep moduloPHPPDV | awk '{print $1}')"
export DOCMOD

cd "$path_trab"

docker stop "$DOCMOD"

if [[ -n "$ZTAR" ]]; then
    echo "Extraindo arquivo: $ZTAR"
    7z x "$ZTAR" -o"$path_trab"
elif [[ -n "$PURO_ZTAR" ]]; then
    echo "Extraindo arquivo: $PURO_ZTAR"
    7z x "/Zanthus/Zeus/pdvJava/PATINTER/ATUVER/$PURO_ZTAR" -o"$path_trab"
elif [[ -n "$ATUAL" ]]; then
    echo "Extraindo arquivo: $ATUAL"
    7z x /Zanthus/Zeus/pdvJava/PATINTER/ATUVER/MDL__"$ATUAL"__php_8_1.AZZ -o"$path_trab" -y
else
    echo "Nada a fazer!"
fi

docker start "$DOCMOD"


