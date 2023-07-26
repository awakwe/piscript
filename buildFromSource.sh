#!/bin/bash

# buildFromSource.sh

# This script extracts source code from a tar or zip archive, builds it, and installs it to a specified directory.

# Function to show an error message and exit
show_error() {
    zenity --error --title="Error" --text="$1"
    exit 1
}

# Ensure necessary tools are installed
command -v make >/dev/null 2>&1 || { echo >&2 "Make is required but it's not installed.  Installing..."; sudo apt-get install -y build-essential; }

# Ask user for the path to the tar or zip file
ARCHIVE_FILE=$(zenity --file-selection --title="Please select the tar or zip file")

# Check if user canceled the file selection
if [[ $? -ne 0 ]]; then
    zenity --info --title="Info" --text="You canceled the operation."
    exit 1
fi

# Extract the archive file
ARCHIVE_DIR="${ARCHIVE_FILE%.*}"
mkdir -p "$ARCHIVE_DIR"

if [[ $ARCHIVE_FILE == *.tar.gz ]]; then
    tar -xzf "$ARCHIVE_FILE" -C "$ARCHIVE_DIR" || show_error "Failed to extract tar.gz file."
elif [[ $ARCHIVE_FILE == *.tar.bz2 ]]; then
    tar -xjf "$ARCHIVE_FILE" -C "$ARCHIVE_DIR" || show_error "Failed to extract tar.bz2 file."
elif [[ $ARCHIVE_FILE == *.tar.xz ]]; then
    tar -xf "$ARCHIVE_FILE" -C "$ARCHIVE_DIR" || show_error "Failed to extract tar.xz file."
elif [[ $ARCHIVE_FILE == *.zip ]]; then
    unzip "$ARCHIVE_FILE" -d "$ARCHIVE_DIR" || show_error "Failed to extract zip file."
else
    show_error "The selected file is not a tar.gz, tar.bz2, tar.xz, or zip file."
fi

SOURCE_DIR="$ARCHIVE_DIR"

# Check if configure script exists
if [[ ! -f "$SOURCE_DIR/configure" ]]; then
    show_error "Configure script not found in source directory."
fi

# Check if Makefile exists
if [[ ! -f "$SOURCE_DIR/Makefile" ]]; then
    show_error "Makefile not found in source directory."
fi

# Ask user for the destination directory
INSTALL_DIR=$(zenity --file-selection --title="Please select the directory to install the program" --directory)

# Check if user canceled the directory selection
if [[ $? -ne 0 ]]; then
    zenity --info --title="Info" --text="You canceled the operation."
    exit 1
fi

# Check if install directory is empty
if [[ "$(ls -A $INSTALL_DIR)" ]]; then
    show_error "Install directory is not empty. Please choose an empty directory to avoid overwriting files."
fi

# Change to the source code directory
cd "$SOURCE_DIR" || show_error "Could not change to source code directory. Please ensure the directory exists and try again."

# Run the configure script
zenity --info --title="Info" --text="Configuring the build..."
if ! ./configure --prefix="$INSTALL_DIR"; then
    show_error "Configure script failed. Please check the source code and try again."
fi

# Compile the program
zenity --info --title="Info" --text="Compiling the program..."
if ! make; then
    show_error "Compilation failed. Please check the source code and try again."
fi

# Install the program
zenity --info --title="Info" --text="Installing the program..."
if ! sudo make install; then
    show_error "Installation failed. Please check the permissions and try again."
fi

# Delete the source directory after installation
rm -rf "$SOURCE_DIR"

# Notify the user of successful installation
zenity --info --title="Success" --text="The program was successfully installed."
