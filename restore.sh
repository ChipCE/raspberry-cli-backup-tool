#!/bin/bash

echo "Revolution image restore tool v1.0"

# set revpi to boot mode
if [[ $1 == "-b" ]] ; then
    echo ""
    sudo rpiboot
fi

echo ""
echo "Target disk list:"
lsblk

echo ""
TARGET_DISK=""
read -p "Enter target disk name (ex: sda) : " TARGET_DISK
while [[ "$TARGET_DISK" == "" ]]
do
    echo "Error : invalid target disk name! $TARGET_DISK"
    read -p "Enter target device Enter target disk name (ex: sda) : " TARGET_DISK
done

echo ""
echo "Available image(s):"
# list image
ls ~/Backup/*.img  | xargs -n 1 basename | sed -e 's/\.img$//'

echo ""
BACKUP_NAME=""
read -p "Enter backup file name : " BACKUP_NAME
while [[ "$BACKUP_NAME" == "" ]]
do
    echo "Error : invalid backup file name! $BACKUP_NAME"
    read -p "Enter backup file name : " BACKUP_NAME
done

# also check for md5sum?
echo ""
echo "Checking checksum of $BACKUP_NAME.img"
CHECKSUM_RESULT=($(md5sum --check ~/Backup/$BACKUP_NAME.md5))
if [[ $CHECKSUM_RESULT == *": OK"* ]]; then
    echo "Checksum : OK"
else
    echo "Checksum : FAILED"
    exit 1
fi

echo ""
echo "Writing image $BACKUP_NAME.img to $TARGET_DISK ..."
sudo dd bs=4M if=~/Backup/$BACKUP_NAME.img of=/dev/$TARGET_DISK

echo ""
echo "Done!"
