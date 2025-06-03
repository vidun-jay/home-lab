#!/bin/bash

set -e

BACKUP_DIR="/var/games/minecraft/archive/yuki"
SERVER_DIR="/var/games/minecraft/servers/yuki"
DATE=$(date +"%Y-%m-%d")
ARCHIVE_NAME="archive-${DATE}.tar.gz"
RCLONE_REMOTE="dropbox:backups/yuki"
EXCLUDE_FLAGS="--exclude=yuki/logs/* --exclude=yuki/.console_history"

mkdir -p "$BACKUP_DIR"

# Run tar in screen to prevent silent hangups
screen -dmS mc-tar-backup bash -c "
cd \"$SERVER_DIR/..\" && \
tar $EXCLUDE_FLAGS -zcvf \"$BACKUP_DIR/$ARCHIVE_NAME\" yuki/
"

# Wait until tar is done by polling the screen session
while screen -list | grep -q mc-tar-backup; do
  sleep 2
done

# Upload to Dropbox
rclone copy "$BACKUP_DIR/$ARCHIVE_NAME" "$RCLONE_REMOTE"

# Keep only the latest 5 backups
rclone lsf "$RCLONE_REMOTE" --files-only | sort | head -n -5 | while read old; do
  rclone delete "$RCLONE_REMOTE/$old"
done

# Send in-game message using rcon-cli via Kubernetes
POD=$(kubectl get pod -l app=minecraft -o jsonpath='{.items[0].metadata.name}')
kubectl exec -n minecraft "$POD" -- rcon-cli 'title @a actionbar {"text":"World synced to cloud successfully.","bold":true,"color":"green"}'
