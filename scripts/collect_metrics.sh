#!/bin/bash

set -e
export LC_ALL=C
umask 022

mkdir -p /opt/infra-metrics
file="/opt/infra-metrics/metrics.tmp"

echo "Collected at: $(date)" > "$file"

echo "CPU information:" >> "$file"
vmstat 1 2 >> "$file"

echo "RAM information:" >> "$file"
free -h >> "$file"

echo "Root disk information:" >> "$file"
df -h / >> "$file"

echo "Container resource usage:" >> "$file"

if systemctl is-active --quiet docker; then
    docker stats --no-stream >> "$file"
else
    echo "Docker is not running." >> "$file"
fi

mv "$file" /opt/infra-metrics/metrics.txt
echo "Metrics updated at $(date)"
