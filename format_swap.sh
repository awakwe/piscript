#!/bin/bash

# Check if the script was run with sudo
if [ "$EUID" -ne 0 ]; then 
  echo "Please run as root"
  exit
fi

# Check if device path argument was provided
if [ -z "$1" ]; then
  echo "Please provide the device path as an argument."
  echo "For example: sudo ./format_and_setup_swap.sh /dev/sdb"
  exit 1
fi

# Define log file
LOG_FILE="format_and_setup_swap.log"

# Define device path
DEVICE_PATH="$1"

# Start logging
echo "Starting script at $(date)" | tee $LOG_FILE

# Check whether the specified path corresponds to a device
if [ ! -b "$DEVICE_PATH" ]; then
    echo "$DEVICE_PATH is not a device. Please check the device path and try again." | tee -a $LOG_FILE
    exit 1
fi

# Log device path
echo "Device Path: $DEVICE_PATH" | tee -a $LOG_FILE

# Format the USB drive
echo "Formatting the USB drive..." | tee -a $LOG_FILE
sudo mkfs.ext4 $DEVICE_PATH | tee -a $LOG_FILE

# Create mount point and mount the drive
echo "Creating mount point and mounting the drive..." | tee -a $LOG_FILE
sudo mkdir -p /mnt/flashdrive
sudo mount $DEVICE_PATH /mnt/flashdrive

# Create swap file
echo "Creating swap file..." | tee -a $LOG_FILE
sudo dd if=/dev/zero of=/mnt/flashdrive/swapfile bs=1M count=1024 | tee -a $LOG_FILE

# Format the swap file and change permissions
echo "Formatting the swap file and changing permissions..." | tee -a $LOG_FILE
sudo mkswap /mnt/flashdrive/swapfile | tee -a $LOG_FILE
sudo chmod 600 /mnt/flashdrive/swapfile

# Enable swap file
echo "Enabling the swap file..." | tee -a $LOG_FILE
sudo swapon /mnt/flashdrive/swapfile

# Add swap to fstab
echo "Adding swap to /etc/fstab..." | tee -a $LOG_FILE
echo '/mnt/flashdrive/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab

echo "Swap file created and enabled on $DEVICE_PATH" | tee -a $LOG_FILE
echo "Script ended at $(date)" | tee -a $LOG_FILE
