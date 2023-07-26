#!/bin/bash

# Function to uninstall and reinstall a specific package
function reinstall {
    echo "Uninstalling $1..."
    pkg uninstall $1

    echo "Reinstalling $1..."
    pkg install $1
}

# Check if package name was provided
if [ -z "$1" ]; then
    echo "Please provide the package name as a command-line argument."
    exit 1
fi

reinstall $1
