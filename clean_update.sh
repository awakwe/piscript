#!/bin/bash
echo "Cleanup system with apt clean..."
sudo apt-get clean

echo "Updating again..."
sudo apt-get update

if [ $? -eq 0 ]; then
    echo "Operation successful. Exiting..."
else
    echo "Operation failed. Please check the logs."
fi
