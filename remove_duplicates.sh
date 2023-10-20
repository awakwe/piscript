#!/bin/bash

# Base directory path
BASE_DIR="C:/Users/uaome/Downloads/other/other_video"

# Loop through numbers 0 to 9
for i in {0..9}
do
    # Construct the full directory path
    DIR_PATH="$BASE_DIR/$i"
    
    # Execute jdupes command on the directory
    jdupes -r -d -N "$DIR_PATH"
done
