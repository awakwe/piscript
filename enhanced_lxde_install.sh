#!/bin/bash

# Log file path
LOGFILE="/var/log/lxde_installation.log"

# Function to log messages with timestamp
log_message() {
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $1" | tee -a $LOGFILE
}

# Safety check: Ensure the script is run as root
if [ "$EUID" -ne 0 ]; then
    log_message "Please run as root."
    exit 1
fi

log_message "Starting the LXDE installation script."

# Update the package list with feedback
log_message "Updating package list..."
sudo apt update | tee -a $LOGFILE
if [ $? -ne 0 ]; then
    log_message "Failed to update package list."
    exit 1
fi

# Prompt user for confirmation before installing packages
read -p "Proceed with installing LXDE, LightDM, and Xorg? (y/n): " confirm_install
if [ "$confirm_install" != "y" ]; then
    log_message "Installation aborted by user."
    exit 0
fi

# Install LXDE, LightDM, and Xorg with feedback
log_message "Installing LXDE, LightDM, and Xorg..."
sudo apt install -y lxde-core lxde lightdm xorg | tee -a $LOGFILE
if [ $? -ne 0 ]; then
    log_message "Installation failed."
    exit 1
fi

# Set LightDM as the default display manager
log_message "Configuring LightDM as the default display manager..."
sudo dpkg-reconfigure lightdm | tee -a $LOGFILE
if [ $? -ne 0 ]; then
    log_message "Failed to configure LightDM."
    exit 1
fi

# Ensure LXDE commands are in the system path with feedback
log_message "Checking if LXDE is in PATH..."
LXDE_PATH=$(which startlxde)

if [[ ":$PATH:" != *":$(dirname $LXDE_PATH):"* ]]; then
    log_message "Adding $(dirname $LXDE_PATH) to PATH..."
    echo "export PATH=\$PATH:$(dirname $LXDE_PATH)" >> ~/.bashrc
    source ~/.bashrc
    log_message "PATH updated."
else
    log_message "LXDE is already in PATH."
fi

# Enable LightDM to start on boot with feedback
log_message "Enabling LightDM to start on boot..."
sudo systemctl enable lightdm | tee -a $LOGFILE
if [ $? -ne 0 ]; then
    log_message "Failed to enable LightDM."
    exit 1
fi

# Prompt user for confirmation before rebooting
read -p "Reboot the server now to apply changes? (y/n): " confirm_reboot
if [ "$confirm_reboot" != "y" ]; then
    log_message "Reboot aborted by user. Please reboot manually to apply changes."
    exit 0
fi

# Reboot the server with feedback
log_message "Rebooting the server to apply changes..."
sudo reboot | tee -a $LOGFILE