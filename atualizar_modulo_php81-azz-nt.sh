#!/bin/bash

LOC="$(pwd)"
DATE="$(date +%d%m%Y)"
DOCKER_USER=""
DOCKER_PASS=""
DIRMOD="/Zanthus/Zeus/pdvJava/GERAL/SINCRO/WEB/moduloPHPPDV"

cd /home/zanthus/
docker rm -f $(docker ps -aq)

rm -rf /Zanthus/Zeus/path_comum_temp/*
rm -rf "$DIRMOD"/moduloPHPPDV*
#cp -av "$LOC"/moduloPHPPDV* "$DIRMOD"/moduloPHPPDV.zip
#unzip -o "$DIRMOD"/moduloPHPPDV.zip -d "$DIRMOD"

source /Zanthus/Zeus/pdvJava/ATUMDL.CFG
source /Zanthus/Zeus/pdvJava/ATUMDL_0.TXT

DOCMOD="$(docker ps | grep moduloPHPPDV | awk '{print $1}')"
export DOCMOD

cd "$path_trab"

docker stop "$DOCMOD"

if [[ -n "$ZTAR" ]]; then
    echo "Extraindo arquivo: $ZTAR"
    7z x "$ZTAR" -o"$path_trab" -y
elif [[ -n "$PURO_ZTAR" ]]; then
    echo "Extraindo arquivo: $PURO_ZTAR"
    7z x "/Zanthus/Zeus/pdvJava/PATINTER/ATUVER/$PURO_ZTAR" -o"$path_trab" -y
elif [[ -n "$ATUAL" ]]; then
    echo "Extraindo arquivo: $ATUAL"
    7z x /Zanthus/Zeus/pdvJava/PATINTER/ATUVER/MDL__"$ATUAL"__php_8_1.AZZ -o"$path_trab" -y
else
    echo "Nada a fazer!"
fi

echo "Realizando login no Docker..."
echo "$DOCKER_PASS" | docker login --username "$DOCKER_USER" --password-stdin


if [ $? -ne 0 ]; then
    echo "Erro: Falha no login do Docker. Verifique as credenciais."
    exit 1
fi

echo "Atualizando os containers..."
cd "$DIRMOD"
docker network create zanthus-network
docker-compose up -d


echo "Fazendo logout do Docker..."
docker logout

echo "Processo concluído com sucesso!"
echo

