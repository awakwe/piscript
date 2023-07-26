#!/bin/bash
echo "Reconfiguring packages with dpkg..."
sudo dpkg --configure -a

if [ $? -eq 0 ]; then
    echo "Operation successful. Exiting..."
else
    echo "Operation failed. Please check the logs."
fi
