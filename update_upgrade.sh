#!/bin/bash

# Function to update and upgrade all packages
function update_and_upgrade {
    echo "Updating and upgrading all packages..."
    pkg upgrade
}

update_and_upgrade
