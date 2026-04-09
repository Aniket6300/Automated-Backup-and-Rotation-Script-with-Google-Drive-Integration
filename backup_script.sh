PROJECT_NAME="project-demo"
PROJECT_DIR="/home/ec2-user/project-demo"

BACKUP_BASE="/home/ec2-user/backups"

DATE=$(date +"%Y%m%d_%H%M%S")

YEAR=$(date +"%Y")
MONTH=$(date +"%m")
DAY=$(date +"%d")

BACKUP_DIR="$BACKUP_BASE/$PROJECT_NAME/$YEAR/$MONTH/$DAY"

LOG_FILE="/home/ec2-user/backup.log"

NOTIFY=true

mkdir -p $BACKUP_DIR

ZIP_NAME="${PROJECT_NAME}_${DATE}.zip"

zip -r $BACKUP_DIR/$ZIP_NAME $PROJECT_DIR

echo "Backup Created: $ZIP_NAME" >> $LOG_FILE

# Upload to Google Drive
rclone copy $BACKUP_DIR/$ZIP_NAME ndrive:ProjectBackups

if [ $? -eq 0 ]
then
    echo "Upload Successful" >> $LOG_FILE

    if [ "$NOTIFY" = true ]; then

    curl -X POST -H "Content-Type: application/json" \
    -d "{\"project\":\"$PROJECT_NAME\",\"date\":\"$DATE\",\"status\":\"BackupSuccessful\"}" \
    https://webhook.site/2da59bde-9c13-4699-a333-23c2ff3ca46b

    fi

else
    echo "Upload Failed" >> $LOG_FILE
fi
# Delete backups older than 7 days

find /home/ec2-user/backups/project-demo -type f -mtime +7 -delete