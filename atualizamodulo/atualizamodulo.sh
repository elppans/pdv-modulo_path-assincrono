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

echo "Atualizando os containers..."
cd "$DIRMOD"
docker network create zanthus-network
docker-compose up -d


echo "Fazendo logout do Docker..."
docker logout

echo "Processo concluído com sucesso!"
echo "Confira se o modulo esta de pe no navegador: http://127.0.0.1:9090/moduloPHPPDV/info.php?key=50245869000174$DATE"
echo "Se estiver em outro computador, acesse: http://$PDVIP:9090/moduloPHPPDV/info.php?key=50245869000174$DATE"
echo


