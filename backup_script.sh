#!/bin/bash

# Backup script using rsync
SOURCE_DIRS="/etc/home/var/www" # add other directories as needed
DEST_DIR="/backup" # Destinatory for backup

# Rsync options: -a for archive, -v for verbose, -z for compressive, and --delete to sync deletions
rsync -avz --delete $SOURCE_DIRS $DEST_DIR

# log the backup
echo "Backup completed on $(date)" >> /var/log/backup.log

if [ $? -ne 0 ]; then
	echo "backup failed on $(date)" | mail -s "backup failure alert" my-email@example.com
else
	echo "backup completed successfully on $(date)" | mail -s "Backup Success Notification" my-email@example.com
f
