#!/bin/bash
echo "RPi image backup tool v1.2"

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
RUNUSER=($(who))

TARGET_DISK=""
BACKUP_NAME=""

echo ""
echo "Listing Disks..."
lsblk
echo ""

read -p "Enter target disk name (E.g. /dev/sda) : " TARGET_DISK
while [[ "$TARGET_DISK" == "" ]]
do
    echo "Error : invalid target disk name! $TARGET_DISK"
    read -p "Enter target disk name (E.g. /dev/sda) : " TARGET_DISK
done

echo ""

read -p "Enter backup file name : " BACKUP_NAME
while [[ "$BACKUP_NAME" == "" ]]
do
    echo "Error : invalid backup file name! $BACKUP_NAME"
    read -p "Enter backup file name : " BACKUP_NAME
done

echo ""

echo "Making ouput folder..."
mkdir -p "$CURRENT_DIR/Backup"

# exit if command failed
set -e 
set -o pipefail

echo ""
echo "Making backup, please wait..."
echo "Target disk : $TARGET_DISK"
echo "Ouput file : $BACKUP_NAME"
sudo dd if=$TARGET_DISK of="$CURRENT_DIR/Backup/$BACKUP_NAME"

# set revpi to boot mode
if [[ $1 == "-s" ]] ; then
    echo ""
    sudo pishrink "$CURRENT_DIR/Backup/$BACKUP_NAME"
fi

echo ""
echo "Caculating md5 checksum of $BACKUP_NAME ..." 
md5sum "$CURRENT_DIR/Backup/$BACKUP_NAME" >> "$CURRENT_DIR/Backup/$BACKUP_NAME.md5"

echo "Changing $BACKUP_NAME and $BACKUP_NAME.md5 file permission..."
sudo chmod 664 "$CURRENT_DIR/Backup/$BACKUP_NAME"
sudo chmod 664 "$CURRENT_DIR/Backup/$BACKUP_NAME.md5"


echo ""

echo "Backup completed!"
