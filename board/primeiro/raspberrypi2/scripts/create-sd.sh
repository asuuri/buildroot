#!/bin/bash


if [[ -b $1 ]]
then
    fdisk -l $1
    read -p "Continue? (y/N): " -n 1 -r doContinue
    echo

    echo $doContinue
    if [[ "$doContinue"=="y" || "$doContinue"=="Y" ]]; then
        echo "Continuing"
    else
        echo "Exiting..."
    fi
fi

