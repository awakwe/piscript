#!/bin/bash

echo "Running Update and Fix script..."
bash update_fix.sh

echo "Running Dpkg Reconfigure script..."
bash dpkg_reconfigure.sh

echo "Running Force Remove Packages script..."
bash remove_packages.sh

echo "Running Clean and Update Again script..."
bash clean_update.sh

echo "All scripts executed successfully."
