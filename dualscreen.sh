#!/bin/bash

# Define the filename
destination='/boot/config.txt'

echo "hdmi_edid_file:1=1" >> $destination
echo "hdmi_edid_filename:1=edid.dat" >> $destination
echo "hdmi_force_hotplug:1=1" >> $destination
