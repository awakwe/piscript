#!/bin/bash

# Define output file
output_file="installed_packages.txt"

# Get list of installed packages
packages=$(dpkg-query -f '${binary:Package}\n' -W)

# Print to console
echo "Installed package names:"
echo "${packages}"

# Save to file
echo "${packages}" > "${output_file}"
echo "Package list saved to ${output_file}"
