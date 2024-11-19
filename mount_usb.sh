#!/bin/bash

# This script automatically mounts USB drives on boot with enhanced reliability and safety.

# --- Configuration ---
MOUNT_POINT_BASE="/mnt"  # Base directory for mount points

# --- Functions ---
log() {
  logger -t "mount_usb" "$@"
}

mount_usb() {
  local device_uuid=$(blkid -s UUID -o value "$device")
  local mount_point="$MOUNT_POINT_BASE/$(basename "$device")1"  # e.g., /mnt/sda1

  # Check if already mounted
  if grep -qs "$mount_point" /proc/mounts; then
    log "Device $device_uuid is already mounted at $mount_point"
    return
  fi

  # Create mount point if it doesn't exist
  if [ ! -d "$mount_point" ]; then
    log "Creating mount point $mount_point"
    sudo mkdir -p "$mount_point"
  fi

  # Mount with options
  sudo mount -o "defaults,nofail,x-systemd.after=network-online.target" UUID="$device_uuid" "$mount_point"

  if [ $? -eq 0 ]; then
    log "Successfully mounted $device_uuid to $mount_point"
  else
    log "Error: Failed to mount $device_uuid to $mount_point"
  fi
}

# --- Main ---
log "Starting USB mount script..."

# Loop through all USB devices
for device in /dev/sd[a-z]1; do
  if [ -b "$device" ]; then
    log "Found USB device: $device"
    mount_usb "$device"
  fi
done

log "Finished USB mount script."
