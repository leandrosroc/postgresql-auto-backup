#!/bin/bash

spinner() {
    local pid=$1
    local delay=0.15
    local spinstr='|/-\'
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf " [%c] " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}

TIMESTAMP=$(date +"%Y%m%d%H%M%S")

#diretório inicial do backup 
BACKUP_INIT="/home/postgres/"

if [ ! -d "$BACKUP_INIT" ]; then
    echo "O diretório de backup não existe no host. Criando..."
    mkdir -p "$BACKUP_INIT"
fi

#diretório final backup
BACKUP_DIR="/www/wwwroot/postgres/backups/"

docker exec postgres-container test -d "$BACKUP_INIT" || docker exec postgres-container mkdir -p "$BACKUP_INIT"

BACKUP_FILE="${BACKUP_INIT}backup_${TIMESTAMP}.sql"

docker exec postgres-container ls "${BACKUP_FILE}" &> /dev/null

if [ $? -eq 0 ]; then
    echo "Backup já existe no contêiner."
else
    # Iniciar o spinner em segundo plano
    spinner $$ &
    SPINNER_PID=$!

    # Criar o backup em segundo plano
    docker exec -i postgres-container pg_dump -U chattyease -d chattyease -f "${BACKUP_FILE}" &
    BACKUP_PID=$!

    # Aguardar o término do backup
    wait $BACKUP_PID

    # Parar o spinner
    kill $SPINNER_PID

    if [ $? -eq 0 ]; then
        echo "Backup criado com sucesso em: ${BACKUP_FILE}"
    else
        echo "Erro ao criar o backup."
        exit 1
    fi
fi

docker cp postgres-container:"${BACKUP_FILE}" "${BACKUP_INIT}"

if [ $? -eq 0 ]; then
    echo "Backup copiado do container para o diretório local do host."

    docker exec postgres-container rm "${BACKUP_FILE}"

    if [ $? -eq 0 ]; then
        echo "Backup removido dentro do container."
    else
        echo "Erro ao remover o backup dentro do container."
    fi
else
    echo "Erro ao copiar o backup do container para o diretório local do host."
fi

mv "${BACKUP_FILE}" "${BACKUP_DIR}"

if [ $? -eq 0 ]; then
    echo "Backup movido para o diretório local do host."
else
    echo "Erro ao mover o backup para o diretório local do host."
fi
