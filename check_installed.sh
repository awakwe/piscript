#!/bin/bash

# Function to check if a specific package is installed
function check_installed {
    echo "Checking if $1 is installed..."
    if pkg list-installed | grep -q "^$1$"; then
        echo "$1 is installed."
    else
        echo "$1 is not installed."
    fi
}

# Check if package name was provided
if [ -z "$1" ]; then
    echo "Please provide the package name as a command-line argument."
    exit 1
fi

check_installed $1
