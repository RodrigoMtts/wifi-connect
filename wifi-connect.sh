#!/bin/bash

#CONF 01 - PASTA COM OS ARQUIVOS .wpa
DIRECTORY="/home/rodrigo/etc/wifi-connect"

#Verifica se existe argumentos
[[ -z $1 ]] && OPTION="" || OPTION=$1

#Verifica se a pasta com os arquivos .wpa existem
[[ -d $DIRECTORY ]] || echo "Pasta $DIRECTORY não existe"

#Pega a quatidade de redes na ~/etc/wifi-connect
WIFI_COUNT=$(ls $DIRECTORY | wc -w)

HELP(){
  echo "
Realiza conxeções com redes wifis já conhecidas

Opções:
  -l, --list-wifis  Lista as conexões conehcidas
  -h, --help        Mostra está mensagem

Exemplos:
  wifi-connect <number> : Conecta ao wifi de número passado
  wifi-connect -l       : Lista todos os wifis diponíveis
  "
}

CONNECT(){
  sleep 2 && wpa_supplicant -i wlx00e02db2280c -c "$DIRECTORY/${WIFIS[$OPTION]}"  &
  sleep 5 && dhclient wlx00e02db2280c
}

#Inicializa o array WIFIS com os nomes dos arquivos .wpa
GET_WIFIS(){
  INDEX=0
  for DIR in $(ls $DIRECTORY)
  do
    WIFIS[$INDEX]=$DIR
    INDEX=$((INDEX+1))
  done
}

LIST_WIFIS(){
  echo ${WIFIS[@]} | sed 's/ /\n/g'
}

set -Eeuo pipefail
trap 'echo "${BASH_SOURCE}:${LINENO}:${FUNCNAME:-}"' ERR

MAIN(){
  GET_WIFIS
  case $OPTION in
    [0-9])
      CONNECT $OPTION
    ;;
    -l | --list-wifis)
      LIST_WIFIS
    ;;
    *)
      HELP
    ;;
  esac
}

MAIN