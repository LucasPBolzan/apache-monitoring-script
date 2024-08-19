#!/bin/bash
DATE=$(date '+%Y-%m-%d %H:%M:%S')
STATUS=$(systemctl is-active httpd)

if [ "$STATUS" = "active" ]; then
    echo "$DATE Apache Service: ONLINE" >> /mnt/compartilhar/lucas/online_status.log
else
    echo "$DATE Apache Service: OFFLINE" >> /mnt/compartilhar/lucas/offline_status.log
fi
