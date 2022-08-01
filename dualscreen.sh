#!/bin/bash

# Define the filename
filename='/boot/config.txt'

# Type the text that you want to append
read -p "hdmi_edid_file:1=1" newtext1

# Check the new text is empty or not
if [ "$newtext1" != "" ]; then
      # Append the text by using '>>' symbol
      echo $newtext1 >> $filename
fi

# Type the text that you want to append
read -p "hdmi_edid_filename:1=edid.dat" newtext2

# Check the new text is empty or not
if [ "$newtext2" != "" ]; then
      # Append the text by using '>>' symbol
      echo $newtext2 >> $filename
fi

# Type the text that you want to append
read -p "hdmi_force_hotplug:1=1" newtext3

# Check the new text is empty or not
if [ "$newtext3" != "" ]; then
      # Append the text by using '>>' symbol
      echo $newtext3 >> $filename
fi
