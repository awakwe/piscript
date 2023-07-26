#!/bin/bash

if command -v apt > /dev/null; then
    SUDO="sudo"
elif command -v pkg > /dev/null; then
    SUDO=""
else
    echo "Neither apt nor pkg found. Can't proceed."
    exit 1
fi

echo "Listing packages that need reinstall..."
REINSTALL_PACKAGES=$(dpkg -l | grep ^..r)

echo "Force remove problematic packages..."
for PKG in $REINSTALL_PACKAGES; do
    $SUDO dpkg --remove --force-remove-reinstreq $PKG
done
