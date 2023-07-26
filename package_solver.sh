#!/bin/bash

# Function to update and upgrade all packages
function update_and_upgrade {
    echo "Updating and upgrading all packages..."
    pkg upgrade
}

# Function to uninstall and reinstall a specific package
function reinstall {
    echo "Uninstalling $1..."
    pkg uninstall $1

    echo "Reinstalling $1..."
    pkg install $1
}

# Function to check if a specific package is installed
function check_installed {
    echo "Checking if $1 is installed..."
    if pkg list-installed | grep -q "^$1$"; then
        echo "$1 is installed."
    else
        echo "$1 is not installed."
        exit 1
    fi
}

# Check if package name was provided
if [ -z "$1" ]; then
    echo "Please provide the problematic package name as a command-line argument."
    exit 1
fi

# Update and upgrade all packages
update_and_upgrade

# Check if the problematic package is installed
check_installed $1

# Uninstall and reinstall the problematic package
reinstall $1

echo "Package problem solver completed."
