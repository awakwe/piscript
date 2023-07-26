#!/bin/bash

# postBuildCleanup.sh

# Function to show an error message and exit
show_error() {
    echo "Error: $1"
    zenity --error --width=200 --height=100 --title="Build Error" --text="$1"
    exit 1
}

# Function to ask user's confirmation for a task
confirm_action() {
    zenity --question --width=200 --height=100 --title="Confirmation Needed" --text="$1"
    return $?
}

# Make sure SOURCE_DIR and LOG_FILE are set
if [ -z "${SOURCE_DIR}" ] || [ -z "${LOG_FILE}" ]; then
    show_error "SOURCE_DIR and LOG_FILE must be set."
fi

# Ask the user if they want to remove the uncompressed source files
if confirm_action "Do you want to remove the uncompressed source files?"; then
    if [[ "$SOURCE_DIR" != "$SOURCE" ]]; then
        rm -rf "$SOURCE_DIR" || show_error "Failed to remove uncompressed source files."
    else
        zenity --info --title="Info" --text="No uncompressed source files to remove."
    fi
fi

# If the previous installation failed due to insufficient permissions, ask the user if they want to retry with sudo
if [[ $? -eq 1 ]]; then
    if confirm_action "The previous installation failed due to insufficient permissions. Do you want to retry with sudo?"; then
        if ! sudo make install >>"$LOG_FILE" 2>&1; then
            show_error "Sudo installation failed. Please check the log file at $LOG_FILE."
        fi
    fi
fi

# Notify the user of successful post-build operations
zenity --info --title="Success" --text="The post-build operations were successful."
