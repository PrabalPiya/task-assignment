#!/bin/bash

set -e

umask 077

today=$(date +%Y%m%d)
folder="/var/backups/db"
file="$folder/db_backup_$today.sql"

mkdir -p "$folder"
chmod 700 "$folder"

if [ -e "$file.gz" ]; then
    echo "Today's backup already exists. Skipping."
    exit 0
fi

docker exec trainee-db pg_dump -U trainee -d trainee_db > "$file"

gzip "$file"

echo "Backup saved: $file.gz"
