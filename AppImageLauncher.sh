#!/bin/bash

# AppImageLauncher.sh

# Function to show an error message
show_error() {
    zenity --error --title="Error" --text="$1"
}

# Ensure Zenity is installed
if ! command -v zenity >/dev/null 2>&1; then
    echo "Zenity is required but it's not installed. Aborting."
    exit 1
fi

while true; do
    FILE_PATH=$(zenity --file-selection --title="Please select an AppImage file")

    # Check if user canceled the file selection
    if [[ $? -ne 0 ]]; then
        zenity --info --title="Info" --text="You canceled the operation."
        break
    fi

    # Check if file exists and is an AppImage
    if [[ -f "$FILE_PATH" && $FILE_PATH == *.AppImage ]]; then
        zenity --info --title="Info" --text="Making the AppImage file executable and launching..."
        chmod a+x "$FILE_PATH"
        "$FILE_PATH" &
        break
    elif [[ -f "$FILE_PATH" ]]; then
        show_error "The file selected is not a valid AppImage file. Please select an AppImage file."
    else
        show_error "The selected file does not exist. Please select a valid file."
    fi
done
