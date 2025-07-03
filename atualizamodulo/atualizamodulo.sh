#!/bin/bash

# Observação:
# 
# 1) Editar o usuário e a senha
# 2) Copie o arquivo moduloPHPPDV_{ULTIMA_VERSAO}_php_8_1.zip para o diretório atualizamodulo

LOC="$(pwd)"
DATE="$(date +%d%m%Y)"
DOCKER_USER="usuario_docker"
DOCKER_PASS="senha_docker"
DIRMOD="/Zanthus/Zeus/pdvJava/GERAL/SINCRO/WEB/moduloPHPPDV"
YML="$DIRMOD/docker-compose.yml"
PDVIP="$(ifconfig eth0 | grep "inet " | awk '{print $2}')"

cd /home/zanthus/
docker rm -f $(docker ps -aq)

rm -rf /Zanthus/Zeus/path_comum_temp/*
rm -rf "$DIRMOD"/moduloPHPPDV*
cp -av "$LOC"/moduloPHPPDV* "$DIRMOD"/moduloPHPPDV.zip
unzip -o "$DIRMOD"/moduloPHPPDV.zip -d "$DIRMOD"

echo "Realizando login no Docker..."
echo "$DOCKER_PASS" | docker login --username "$DOCKER_USER" --password-stdin


if [ $? -ne 0 ]; then
    echo "Erro: Falha no login do Docker. Verifique as credenciais."
    exit 1
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


