#!/bin/bash
# Backup automático MongoDB
FECHA=$(date +%Y%m%d_%H%M%S)
docker exec rappicampo_mongodb mongodump --out /backups/mongo_$FECHA/
echo "✅ Backup MongoDB: /backups/mongo_$FECHA/"
