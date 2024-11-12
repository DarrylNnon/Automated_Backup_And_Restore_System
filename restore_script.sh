#!/bin/bash

# Restore script using rsync
SOURCE_DIR="/backup" # source directory for backup
DEST_DIRS="/etc /home /var/www"  # Destination directories to restore

# Rsync restore

for DEST_DIR in $DEST_DIRS; do
	rsync -avz $SOURCE_DIR/$(basename $DEST_DIR) $DEST_DIR
done

# log the restore
echo "Restore completed $(date)" >> /var/log/restore.log


