#!/bin/bash
echo "Listing packages that need reinstall..."
REINSTALL_PACKAGES=$(sudo dpkg -l | grep ^..r)

echo "Force remove problematic packages..."
for PKG in $REINSTALL_PACKAGES; do
    sudo dpkg --remove --force-remove-reinstreq $PKG
done

if [ $? -eq 0 ]; then
    echo "Operation successful. Exiting..."
else
    echo "Operation failed. Please check the logs."
fi
