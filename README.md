# Automated Backup And Restore System
This project project is a step-by-step guide for setting up a comprehensive automated backup and restore system using Linux, with details for each stage that will allow me to implement and train others in this essential administrative skill.I will design it in a way that's scalable, easy to maintain, and supports automation and manual intervention in case of emergency.


## *1. Create a Backup Script with rsync or tar**

### Goal:
The primary goal is to ensure critical files and directories are regularly backed up. We’ll use `rsync` for efficient incremental backups, though `tar` can also be useful for compressing files for smaller storage.

### **Steps to Create a Backup Script with `rsync`:**

#### **Step 1.1**: Identify Directories and Files to Backup
   - Determine which files and directories need to be backed up, such as `/etc`, `/home`, application data directories, or databases.
   - Make a list of paths to ensure these are properly backed up and documented for future reference.

#### **Step 1.2**: Write the `rsync` Backup Script
1. **Open a new script file** (e.g., `backup_script.sh`):
   ```bash
   sudo nano /usr/local/bin/backup_script.sh
   ```

2. **Add the following script to backup selected directories**:
   ```bash
   #!/bin/bash
   # Backup Script using rsync
   SOURCE_DIRS="/etc /home /var/www"  # Add other directories as needed
   DEST_DIR="/backup"  # Destination directory for backup

   # Rsync options: -a for archive, -v for verbose, -z for compression, and --delete to sync deletions
   rsync -avz --delete $SOURCE_DIRS $DEST_DIR

   # Log the backup
   echo "Backup completed on $(date)" >> /var/log/backup.log
   ```

3. **Save and exit the script** and make it executable:
   ```bash
   chmod +x /usr/local/bin/backup_script.sh
   ```

#### **Step 1.3**: Test the Script
   - Run the script to ensure it works as expected and verify the contents in the destination directory (`/backup`).
   ```bash
   sudo /usr/local/bin/backup_script.sh
   ```

### Optional: Use `tar` for Full Archives
   - You can add a full archive script using `tar` if you want compressed backups:
   ```bash
   tar -czvf /backup/backup-$(date +%F).tar.gz /etc /home /var/www
   ```

## **2. Schedule Backups Using cron**

### Goal:
Automate the backup process by scheduling it at appropriate times using `cron`, ensuring backups occur regularly without manual intervention.

### **Steps to Schedule the Backup Script with `cron`:**

#### **Step 2.1**: Open the Crontab
   ```bash
   sudo crontab -e
   ```

#### **Step 2.2**: Add a cron Job to Run the Script Daily
   - For daily backups at midnight, add the following line to the crontab:
   ```bash
   0 0 * * * /usr/local/bin/backup_script.sh
   ```

   - **Explanation**:
     - `0 0 * * *`: Runs every day at midnight.
     - `/usr/local/bin/backup_script.sh`: Path to your backup script.

#### Step 2.3: Verify the cron Job
   - Check that the job has been added by listing the scheduled cron jobs:
   ```bash
   sudo crontab -l
   ```

   - Monitor `/var/log/backup.log` to confirm backups are being recorded as scheduled.


## 3. Automate Restore Process with Pre-Defined Backup Paths**

### Goal:
Create a script that automates the restoration process, ensuring you can quickly recover files and directories from the backup in case of data loss.

### **Steps to Create a Restore Script:**

#### **Step 3.1**: Write the Restore Script
1. **Open a new script file** (e.g., `restore_script.sh`):
   ```bash
   sudo nano /usr/local/bin/restore_script.sh
   ```

2. **Add the following restore commands**:
   ```bash
   #!/bin/bash
   # Restore Script using rsync
   SOURCE_DIR="/backup"  # Source directory for backup
   DEST_DIRS="/etc /home /var/www"  # Destination directories to restore

   # Rsync restore
   for DEST_DIR in $DEST_DIRS; do
       rsync -avz $SOURCE_DIR/$(basename $DEST_DIR) $DEST_DIR
   done

   # Log the restore
   echo "Restore completed on $(date)" >> /var/log/restore.log
   ```

3. **Save and exit the script** and make it executable:
   ```bash
   chmod +x /usr/local/bin/restore_script.sh
   ```

#### **Step 3.2**: Test the Restore Script
   - Run the script to confirm it restores files to their original locations:
   ```bash
   sudo /usr/local/bin/restore_script.sh
   ```

   - Check `/var/log/restore.log` for a record of the restore operations.


## **4. Document and Test the Backup/Restore System**

### Goal:
Ensure all stakeholders understand how the backup and restore system works, test it regularly, and document it clearly.

### **Steps to Document and Verify the System:**

#### **Step 4.1**: Create Detailed Documentation
   - Describe each part of the system in a document (e.g., `Backup_Restore_Guide.md`) that covers:
     - **Backup Locations**: Paths of critical files and directories.
     - **Backup and Restore Commands**: Details of `backup_script.sh` and `restore_script.sh`.
     - **cron Scheduling**: Explain the cron job setup and schedule.
     - **Logs and Monitoring**: Outline log locations (`/var/log/backup.log` and `/var/log/restore.log`).

#### **Step 4.2**: Schedule Regular Tests
   - To ensure reliability, test the backup and restore process periodically (e.g., monthly):
     - Perform a **test restore** to a temporary directory and verify file integrity.
     - Use a checklist to confirm all parts of the system are operational.

#### **Step 4.3**: Implement Additional Monitoring and Alerts (Optional)
   - Consider configuring email or Slack notifications for backup completion, failure alerts, or log monitoring.

   - **Example of Email Alert Using `mail`**:
     - Add the following line to the end of the `backup_script.sh`:
     ```bash
     if [ $? -ne 0 ]; then
         echo "Backup failed on $(date)" | mail -s "Backup Failure Alert" your-email@example.com
     else
         echo "Backup completed successfully on $(date)" | mail -s "Backup Success Notification" your-email@example.com
     fi
     ```

This solution provides a fully automated, reliable, and maintainable backup and restore system that can be implemented in a production environment, with proper documentation and regular testing to ensure data safety and system recovery readiness. This approach will enable me to teach my team and maintain an efficient backup system with confidence.
