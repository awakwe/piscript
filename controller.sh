#!/bin/bash
# controller.sh

# Source utility scripts
source ./remove-unused-packages.sh
source ./check-disk-usage.sh
source ./list-apt-sources.sh
source ./remove-problematic-repo.sh

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

# Check for problematic APT sources
echo "Checking APT sources..."
list_apt_sources

# If a known problematic source is found, remove it
if grep -q "problematic-repo" /etc/apt/sources.list; then
    echo "Problematic repository found. Attempting removal..."
    remove_problematic_repo
fi

echo "All tasks completed."
