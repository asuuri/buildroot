#!/bin/bash

if [ ! $1 ]; then
    echo "USAGE: $0 <drive>|-l"
    exit -1
fi

if [[ $1 == '-l' ]]; then
    echo "---"
    parted -s -l 2> /dev/null | grep -e '\(Model:\|Disk \/\)' | sed '/Disk /a ---' --
    exit
fi

drive=$1

if [[ -b $drive ]]; then
    fdisk -l $drive
    read -p "Continue? (y/N): " -r doContinue
    echo

    if [[ $doContinue =~ ^[Yy]$ ]]; then
        echo
        echo "## Unmounting"
        for n in "$drive*" ; do
            umount $n > /dev/null 2>&1
        done

        echo
        echo "## Cleaning disk"
        dd if=/dev/zero of=$drive bs=1024 count=1024

        echo
        echo "## Creating partitions and filesystem"
        parted $drive -s mklabel msdos
        parted $drive -a optimal -s mkpart primary fat32 0% 50
        parted $drive -s set 1 boot on
        parted $drive -a optimal -s mkpart primary ext3 50 100%

        mkfs.msdos -F 32 "${drive}1" -n BOOT
        mkfs.ext3 -F "${drive}2"

        echo
        echo "## Mounting"
        BOOT_MOUNT_POINT="/mnt/buildroot/boot"
        ROOT_MOUNT_POINT="/mnt/buildroot/root"
        mkdir -p $BOOT_MOUNT_POINT
        mkdir -p $ROOT_MOUNT_POINT

        mount "${drive}1" $BOOT_MOUNT_POINT
        mount "${drive}2" $ROOT_MOUNT_POINT

        echo
        echo "## Creating boot section"
        cp output/images/rpi-firmware/* $BOOT_MOUNT_POINT
        cp output/images/*.dtb $BOOT_MOUNT_POINT

        `pwd`/output/host/usr/bin/mkknlimg output/images/zImage "${BOOT_MOUNT_POINT}/zImage"

        echo
        echo "## Creating root section"
        tar xf `pwd`/output/images/rootfs.tar -C $ROOT_MOUNT_POINT

        echo
        echo "## Unmounting"
        umount $BOOT_MOUNT_POINT $ROOT_MOUNT_POINT
        rm -Rf /mnt/buildroot

        echo "## Ready"
    else
        echo "Exiting..."
    fi
else
    echo "Could not find disk $drive"
fi

