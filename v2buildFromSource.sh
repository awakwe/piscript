#!/bin/bash

# buildFromSource.sh

# Function to show an error message and exit
show_error() {
    echo "Error: $1"
    exit 1
}

# Ensure necessary tools are installed
for tool in make gcc g++ cmake unzip; do
    if ! command -v $tool >/dev/null 2>&1; then
        echo >&2 "$tool is required but it's not installed. Installing..."
        sudo apt-get install -y $tool || show_error "Failed to install $tool."
    fi
done

# Ask user for the path to the source code directory or zip file
SOURCE=$(zenity --file-selection --title="Please select the source code directory or zip file")

# Check if user canceled the directory selection
if [[ $? -ne 0 ]]; then
    zenity --info --title="Info" --text="You canceled the operation."
    exit 1
fi

# If the source is a zip file, extract it
if [[ "$SOURCE" == *.zip ]]; then
    # Extract zip file
    zenity --info --title="Info" --text="Extracting zip file..."
    unzip -q "$SOURCE" -d "${SOURCE%.*}" || show_error "Failed to extract zip file."
    SOURCE_DIR="${SOURCE%.*}"
else
    SOURCE_DIR="$SOURCE"
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
(
echo "10" ; sleep 1
echo "# Compiling the program..." ; make || show_error "Compilation failed. Please check the source code and try again."
echo "80" ; sleep 1

# Install the program
echo "# Installing the program..." ; sudo make install || show_error "Installation failed. Please check the permissions and try again."
echo "100" ; sleep 1
) |
zenity --progress \
  --title="Build progress" \
  --text="Starting..." \
  --percentage=0 \
  --auto-close \
  --auto-kill

[[ "$?" != -1 ]] && zenity --info --title="Success" --text="The program was successfully installed."
