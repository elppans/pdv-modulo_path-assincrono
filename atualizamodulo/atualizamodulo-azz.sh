#!/bin/bash

# Observação:
# 
# 1) Editar o usuário e a senha
# 2) Copie o arquivo moduloPHPPDV_{ULTIMA_VERSAO}_php_8_1.zip para o diretório atualizamodulo

LOC="$(pwd)"
DATE="$(date +%d%m%Y)"
DIRMOD="/Zanthus/Zeus/pdvJava/GERAL/SINCRO/WEB/moduloPHPPDV"
YML="$DIRMOD/docker-compose.yml"
PDVIP="$(ifconfig eth0 | grep "inet " | awk '{print $2}')"

DOCKER_USER=""
DOCKER_PASS=""

# Se as variáveis estiverem vazias, pede login
if [ -z "$DOCKER_USER" ] || [ -z "$DOCKER_PASS" ]; then
    echo -e "Realizando login no Docker...\n"
    read -p "Digite seu usuário Docker: " DOCKER_USER
    read -s -p "Digite sua senha Docker: " DOCKER_PASS
    echo ""
fi

echo "Acessando Docker..."
echo "$DOCKER_PASS" | docker login --username "$DOCKER_USER" --password-stdin

# Opcional: verificar se o login foi bem-sucedido
if [ $? -eq 0 ]; then
    echo "Login realizado com sucesso!"
else
    echo "Falha no login."
    exit 1
fi

echo "Forçando parada do Docker..."
cd /home/zanthus/
docker rm -f $(docker ps -aq)

echo "Atualizando moduloPHPPDV..."
rm -rf /Zanthus/Zeus/path_comum_temp/*
rm -rf "$DIRMOD"/moduloPHPPDV*
# cp -av "$LOC"/moduloPHPPDV* "$DIRMOD"/moduloPHPPDV.zip
# unzip -o "$DIRMOD"/moduloPHPPDV.zip -d "$DIRMOD"

source /Zanthus/Zeus/pdvJava/ATUMDL.CFG
source /Zanthus/Zeus/pdvJava/ATUMDL_0.TXT

DOCMOD="$(docker ps | grep moduloPHPPDV | awk '{print $1}')"
export DOCMOD

cd "$path_trab"

docker stop "$DOCMOD"

if [[ -n "$PURO_ZTAR" ]]; then
    echo "Extraindo arquivo: $PURO_ZTAR"
    7z x "/Zanthus/Zeus/pdvJava/PATINTER/ATUVER/$PURO_ZTAR" -o"$path_trab" -y
elif [[ -n "$ZTAR" ]]; then
    echo "Extraindo arquivo: $ZTAR"
    7z x "$ZTAR" -o"$path_trab" -y
elif [[ -n "$ATUAL" ]]; then
    echo "Extraindo arquivo: $ATUAL"
    7z x /Zanthus/Zeus/pdvJava/PATINTER/ATUVER/MDL__"$ATUAL"__php_8_1.AZZ -o"$path_trab" -y
else
    echo "Nada a fazer!"
fi

if [ ! -f "$YML" ]; then
echo -e '#*********MODULOPHPPDV********* 
networks:
  zanthus-network:
    driver: bridge
    external: true
services:
  moduloPHPPDV:
    image: zanthusinovacao1/managerweb:moduloPHPPDV
    restart: always
    hostname: moduloPHPPDV
    container_name: moduloPHPPDV
    privileged: true
    entrypoint: ./entrypoint.sh
    ports:
      - "9090:9090"
    networks:
      - zanthus-network
    environment:
      - TZ=America/Bahia
    volumes:
      - /Zanthus/Zeus/pdvJava/GERAL/SINCRO/WEB:/usr/local/php/moduloPHPPDV
      - /Zanthus/Zeus/pdvJava/GERAL/SINCRO/WEB/moduloPHPPDV/php_errors.log:/tmp/php_errors.log
' | sudo tee "$YML" &>>/dev/null
fi

echo "Atualizando os containers..."
cd "$DIRMOD"
>php_errors.log
docker network inspect zanthus-network >/dev/null 2>&1 || docker network create zanthus-network
docker-compose up -d


echo "Fazendo logout do Docker..."
docker logout

echo "Processo concluído com sucesso!"
echo "Confira se o modulo esta de pe no navegador: http://127.0.0.1:9090/moduloPHPPDV/info.php?key=50245869000174$DATE"
echo "Se estiver em outro computador, acesse: http://$PDVIP:9090/moduloPHPPDV/info.php?key=50245869000174$DATE"
echo
