#!/bin/bash
# implement.sh

# Request the path to the script directory from the user
echo "Enter the path to the directory containing the scripts:"
read script_path

# Navigate to the script directory
cd "$script_path" || exit

# Check if the required scripts are present
for script in remove-unused-packages.sh check-disk-usage.sh list-apt-sources.sh remove-problematic-repo.sh controller.sh
do
    if [[ ! -f $script ]]; then
        echo "Error: $script not found in the specified directory."
        exit 1
    fi
done

# Make the scripts executable
chmod +x *.sh

# Run the controller script
sudo ./controller.sh
