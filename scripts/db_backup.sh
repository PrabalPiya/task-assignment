#!/bin/bash

set -e

today=$(date +%Y%m%d)
folder="/var/backups/db"
file="$folder/db_backup_$today.sql"

mkdir -p "$folder"

docker exec trainee-db pg_dump -U trainee -d trainee_db > "$file"

gzip "$file"

echo "Backup saved: $file.gz"
