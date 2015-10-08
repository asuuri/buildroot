#!/bin/bash

if [ ! $1 ]; then
    echo "USAGE: $0 <drive>|-l"
    exit -1
fi

if [[ $1 == '-l' ]]; then
    echo "---"
    parted -l 2> /dev/null | grep -e '\(Model:\|Disk \/\)' | sed '/Disk /a ---' --
    exit
fi

drive=$1

if [[ -b $drive ]]; then
    fdisk -l $drive
    read -p "Continue? (y/N): " -n 1 -r doContinue
    echo

    if [[ $doContinue =~ ^[Yy]$ ]]; then
        # Unmounting drives
        echo "## Unmounting"
        for n in "$drive*" ; do 
            umount $n > /dev/null 2>&1
        done

        echo "## Clearing disk"
        dd if=/dev/zero of=$drive bs=1024 count=1024

        echo "Continuing"
    else
        echo "Exiting..."
    fi
else
    echo "Could not find disk $drive"
fi

