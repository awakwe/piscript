#!/bin/bash

# buildFromSource.sh

# Function to show an error message and exit
show_error() {
    echo "Error: $1"
    zenity --error --width=200 --height=100 --title="Build Error" --text="$1"
    exit 1
}

# Ensure necessary tools are installed
for tool in make gcc g++ cmake unzip tar; do
    if ! command -v $tool >/dev/null 2>&1; then
        echo >&2 "$tool is required but it's not installed. Installing..."
        sudo apt-get install -y $tool || show_error "Failed to install $tool."
    fi
done

# Ask user for the path to the source code directory or archive file
SOURCE=$(zenity --file-selection --title="Please select the source code directory or archive file")

# Check if user canceled the directory selection
if [[ $? -ne 0 ]]; then
    zenity --info --title="Info" --text="You canceled the operation."
    exit 1
fi

# If the source is a zip, tar.gz, or tar.bz2 file, extract it
if [[ "$SOURCE" == *.zip ]]; then
    # Extract zip file
    zenity --info --title="Info" --text="Extracting zip file..."
    unzip -q "$SOURCE" -d "${SOURCE%.*}" || show_error "Failed to extract zip file."
    export SOURCE_DIR="${SOURCE%.*}"
elif [[ "$SOURCE" == *.tar.gz ]]; then
    # Extract tar.gz file
    zenity --info --title="Info" --text="Extracting tar.gz file..."
    tar -xzf "$SOURCE" -C "${SOURCE%.*}" || show_error "Failed to extract tar.gz file."
    export SOURCE_DIR="${SOURCE%.*}"
elif [[ "$SOURCE" == *.tar.bz2 ]]; then
    # Extract tar.bz2 file
    zenity --info --title="Info" --text="Extracting tar.bz2 file..."
    tar -xjf "$SOURCE" -C "${SOURCE%.*}" || show_error "Failed to extract tar.bz2 file."
    export SOURCE_DIR="${SOURCE%.*}"
else
    SOURCE_DIR="$SOURCE"
fi

# Log file for the build process
export LOG_FILE="${SOURCE_DIR}/build.log"

# Check if configure script exists
if [[ -f "$SOURCE_DIR/configure" ]]; then
    # Run the configure script
    zenity --info --title="Info" --text="Configuring the build..."
    if ! "$SOURCE_DIR/configure" >"$LOG_FILE" 2>&1; then
        show_error "Configure script failed. Please check the log file at $LOG_FILE."
    fi
# Check if CMakeLists.txt file exists
elif [[ -f "$SOURCE_DIR/CMakeLists.txt" ]]; then
    # Create a separate build directory
    mkdir -p "$SOURCE_DIR/build"
    cd "$SOURCE_DIR/build"

    # Run cmake
    zenity --info --title="Info" --text="Configuring the build..."
    if ! cmake .. >"$LOG_FILE" 2>&1; then
        show_error "CMake configuration failed. Please check the log file at $LOG_FILE."
    fi
else
    show_error "Neither configure script nor CMakeLists.txt found in source directory."
fi

# Compile the program
zenity --info --title="Info" --text="Compiling the program..."
if ! make >>"$LOG_FILE" 2>&1; then
    show_error "Compilation failed. Please check the log file at $LOG_FILE."
fi

# Install the program
zenity --info --title="Info" --text="Installing the program..."
if ! sudo make install >>"$LOG_FILE" 2>&1; then
    show_error "Installation failed. Please check the log file at $LOG_FILE."
fi

# Run postBuildCleanup.sh
bash "$(dirname "$0")/postBuildCleanup.sh"

# Notify the user of successful installation
zenity --info --title="Success" --text="The program was successfully installed."
