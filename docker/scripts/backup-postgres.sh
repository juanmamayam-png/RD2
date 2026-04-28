#!/bin/bash
# Backup automático PostgreSQL
FECHA=$(date +%Y%m%d_%H%M%S)
DIR="/backups/postgres"
mkdir -p $DIR
docker exec rappicampo_postgres pg_dump -U ${POSTGRES_USER} ${POSTGRES_DB} \
  > $DIR/rappicampo_$FECHA.sql
echo "✅ Backup PostgreSQL: $DIR/rappicampo_$FECHA.sql"
find $DIR -name "*.sql" -mtime +30 -delete
