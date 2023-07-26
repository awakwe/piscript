#!/bin/bash

# preBuildFromSource.sh

REQUIRED_DISK_SPACE=5000000  # 5 GB. Adjust as needed.
REQUIRED_TOOLS=(make gcc g++ cmake unzip tar)

# Function to show an error message and exit
show_error() {
    echo "Error: $1"
    zenity --error --width=200 --height=100 --title="Build Error" --text="$1"
    exit 1
}

# Function to install and update a tool
install_update_tool() {
    local tool=$1
    if ! command -v $tool >/dev/null 2>&1; then
        echo >&2 "$tool is required but it's not installed. Installing..."
        sudo apt-get install -y $tool || show_error "Failed to install $tool."
    fi
    echo >&2 "Updating $tool..."
    sudo apt-get upgrade -y $tool || show_error "Failed to update $tool."
}

# Check if there is enough disk space before starting the build
AVAILABLE_DISK_SPACE=$(df . | awk 'NR==2 {print $4}')
if [[ $AVAILABLE_DISK_SPACE -lt $REQUIRED_DISK_SPACE ]]; then
    show_error "Not enough disk space. At least $((REQUIRED_DISK_SPACE/1000000)) GB is required."
fi

# Ensure necessary tools are installed and up-to-date
for tool in "${REQUIRED_TOOLS[@]}"; do
    install_update_tool $tool
done

# Run buildFromSource.sh
bash "$(dirname "$0")/buildFromSource.sh"
