#!/bin/bash
echo "Updating packages list..."
sudo apt-get update --fix-missing

echo "Force installation of required packages..."
sudo apt-get install -f

echo "Fixing broken installs..."
sudo apt-get --fix-broken install

echo "Performing a full upgrade..."
sudo apt-get full-upgrade -y

if [ $? -eq 0 ]; then
    echo "Operation successful. Exiting..."
else
    echo "Operation failed. Please check the logs."
fi
