#!/bin/bash
echo "RPi image backup tool v1.0"

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# set revpi to boot mode
if [[ $1 == "-b" ]] ; then
    echo ""
    sudo rpiboot
fi


TARGET_DISK=""
BACKUP_NAME=""

echo ""
echo "Listing Disks..."
lsblk
echo ""

read -p "Enter target disk name (ex: sda) : " TARGET_DISK
while [[ "$TARGET_DISK" == "" ]]
do
    echo "Error : invalid target disk name! $TARGET_DISK"
    read -p "Enter target device Enter target disk name (ex: sda) : " TARGET_DISK
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

echo ""
echo "Making backup, please wait..."
echo "Disk : $TARGET_DISK"
echo "Ouput file : $BACKUP_NAME"
sudo dd if=/dev/$TARGET_DISK of="$CURRENT_DIR/Backup/$BACKUP_NAME"

echo ""
echo "Caculating md5 checksum of $BACKUP_NAME.img" 
md5sum "$CURRENT_DIR/Backup/$BACKUP_NAME" >> "$CURRENT_DIR/Backup/$BACKUP_NAME.md5"

echo ""

echo "Backup completed!"
