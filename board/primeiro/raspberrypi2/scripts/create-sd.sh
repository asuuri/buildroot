#!/bin/bash

if [ ! $1 ]; then
    echo "USAGE: $0 <drive>"
    exit -1
fi

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

