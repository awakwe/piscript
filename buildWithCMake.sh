#!/bin/bash

# buildWithCMake.sh

# Function to show an error message and exit
show_error() {
    echo "Error: $1"
    exit 1
}

# Ensure necessary tools are installed
for tool in make gcc g++ cmake; do
    if ! command -v $tool >/dev/null 2>&1; then
        echo >&2 "$tool is required but it's not installed. Installing..."
        sudo apt-get install -y $tool || show_error "Failed to install $tool."
    fi
done

# Ask user for the path to the source code directory
SOURCE_DIR=$(zenity --file-selection --title="Please select the source code directory" --directory)

# Check if user canceled the directory selection
if [[ $? -ne 0 ]]; then
    zenity --info --title="Info" --text="You canceled the operation."
    exit 1
fi

# Check if configure script exists
if [[ -f "$SOURCE_DIR/configure" ]]; then
    # Run the configure script
    zenity --info --title="Info" --text="Configuring the build..."
    if ! "$SOURCE_DIR/configure"; then
        show_error "Configure script failed. Please check the source code and try again."
    fi
# Check if CMakeLists.txt file exists
elif [[ -f "$SOURCE_DIR/CMakeLists.txt" ]]; then
    # Create a separate build directory
    mkdir -p "$SOURCE_DIR/build"
    cd "$SOURCE_DIR/build"

    # Run cmake
    zenity --info --title="Info" --text="Configuring the build..."
    if ! cmake ..; then
        show_error "CMake configuration failed. Please check the source code and try again."
    fi
else
    show_error "Neither configure script nor CMakeLists.txt found in source directory."
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

# Notify the user of successful installation
zenity --info --title="Success" --text="The program was successfully installed."
