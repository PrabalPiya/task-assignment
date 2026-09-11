#!/bin/bash

echo "CPU information:"
vmstat 1 2

echo "RAM information:"
free -h

echo "Disk information:"
df -h /

time=$(date)
log="/var/log/infra_health.log"

disk=$(df --output=pcent / | tail -n 1 | tr -d ' %')

if [ -z "$disk" ]; then
    echo "$time [WARNING] Could not read disk usage." | tee -a "$log"
    exit 1
else [ "$disk" -gt 85 ]; then
    echo "$time [WARNING] Disk usage is above 85%." | tee -a "$log"
fi

if systemctl is-active --quiet docker; then
    echo "Docker is running."
else
    echo "$time [WARNING] Docker is not running." | tee -a "$log"
fi

app=$(docker inspect --format '{{.State.Running}}' trainee-app 2>/dev/null)

if [ "$app" = "true" ]; then
    echo "Application container is running."
else
    echo "$time [WARNING] Application is stopped or cannot be checked." | tee -a "$log"
fi
