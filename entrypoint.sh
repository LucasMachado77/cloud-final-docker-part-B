#!/bin/sh
set -e

# Exporta as variáveis de ambiente a partir dos ficheiros de segredos
export DB_HOST=${DB_HOST:-db}
export DB_PORT=${DB_PORT:-5432}
export DB_NAME=$(cat /run/secrets/db_name)
export DB_USER=$(cat /run/secrets/db_user)
export DB_PASS=$(cat /run/secrets/db_pass)

# Executa o comando principal passado ao contentor (o 'apache2-foreground')
exec "$@"