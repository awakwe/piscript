#!/bin/bash

# Check if script is run as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

# Check if testdisk and photorec are installed
if ! command -v testdisk &> /dev/null || ! command -v photorec &> /dev/null; then
    echo "testdisk and photorec are required but not installed. Install them and run the script again."
    exit 1
fi

# List all storage devices
echo "Listing all storage devices..."
lsblk

# Prompt the user to enter the device name
echo "Enter the device name of your SD card (e.g., sdb1):"
read device_name

# Create an image of the SD card
echo "Creating an image of the SD card..."
dd if=/dev/$device_name of=sdcard.img

# Use testdisk to recover data
echo "Starting testdisk..."
testdisk /dev/$device_name

# If testdisk fails, ask the user if they want to use photorec
if [ $? -ne 0 ]; then
    echo "Testdisk failed. Do you want to use photorec? (y/n)"
    read answer
    if [ "$answer" != "${answer#[Yy]}" ] ;then
        echo "Starting photorec..."
        photorec /dev/$device_name
    fi
fi

echo "Data recovery completed. Please check the output files."
