#!/bin/bash
# remove-unused-packages.sh
echo "Removing old kernels and unused packages..."
sudo apt-get autoremove -y
echo "Done"
