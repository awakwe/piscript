#!/bin/bash
# controller.sh

# Source utility scripts
source ./remove-unused-packages.sh
source ./check-disk-usage.sh
source ./list-apt-sources.sh
source ./generate_problematic_repo_list.sh
source ./remove_problematic_repo.sh
source ./check_network.sh

function check_boot_disk_usage {
    # Check disk usage in /boot
    echo "Checking /boot disk usage..."
    boot_usage=$(df --output=pcent /boot | tail -n 1 | tr -dc '0-9')
    echo "/boot is $boot_usage% full."

    # If /boot is more than 90% full, attempt to clean up
    if [ $boot_usage -gt 90 ]; then
        echo "/boot is over 90% full. Attempting cleanup..."
        remove_unused_packages
    fi

    # Recheck disk usage in /boot
    boot_usage=$(df --output=pcent /boot | tail -n 1 | tr -dc '0-9')
    echo "/boot is $boot_usage% full."

    # If /boot is still too full, warn the user
    if [ $boot_usage -gt 90 ]; then
        echo "Warning: /boot is still over 90% full."
    fi
}

function check_apt_sources {
    # Check for problematic APT sources
    echo "Checking APT sources..."
    list_apt_sources

    # If a known problematic source is found, remove it
    if grep -q "problematic-repo" /etc/apt/sources.list; then
        echo "Problematic repository found. Attempting removal..."
        remove_problematic_repo
    fi
}

function check_network_and_repos {
    # Check for network connectivity
    echo "Checking network connectivity..."
    check_network
    if [ $? -ne 0 ]; then
        echo "Network connectivity issue detected. Please check your connection and try again."
        exit 1
    fi

    # Generate list of problematic repos
    echo "Generating list of problematic repositories..."
    generate_problematic_repo_list
    if [ $? -ne 0 ]; then
        echo "No problematic repositories detected."
        exit 0
    fi
}

# Check if script was called with arguments
if [ $# -gt 0 ]; then
    echo "Running script with arguments: $@"
    # Add functionality here to handle the arguments as needed
else
    echo "Running script without any arguments..."
fi

# Run the checks
check_network_and_repos
check_boot_disk_usage
check_apt_sources

echo "All tasks completed."
