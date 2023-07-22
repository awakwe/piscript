#!/bin/bash

# Updating Termux repo
pkg update

# Installing necessary packages
pkg install proot-distro ffmpeg -y

# Installing Ubuntu
proot-distro install ubuntu

# Updating and upgrading the packages in Ubuntu
proot-distro login ubuntu -- apt update && apt upgrade -y

# Installing necessary packages
proot-distro login ubuntu -- apt install curl gnupg -y

# Step 3: Download the GPG signing key
proot-distro login ubuntu -- bash -c 'mkdir -p /etc/apt/keyrings && curl -fsSL https://repo.jellyfin.org/jellyfin_team.gpg.key | gpg --dearmor -o /etc/apt/keyrings/jellyfin.gpg'

# Step 4: Add a repository configuration
proot-distro login ubuntu -- bash -c 'echo -e "Types: deb\nURIs: https://repo.jellyfin.org/ubuntu\nSuites: focal\nComponents: main\nArchitectures: arm64\nSigned-By: /etc/apt/keyrings/jellyfin.gpg" | tee /etc/apt/sources.list.d/jellyfin.sources'

# Step 5: Update APT repositories
proot-distro login ubuntu -- apt update

# Step 6: Install Jellyfin
proot-distro login ubuntu -- apt install jellyfin

# Creating a symbolic link for Jellyfin web client
proot-distro login ubuntu -- ln -s /usr/share/jellyfin/web /usr/lib/jellyfin/bin/jellyfin-web

# Running Jellyfin
proot-distro login ubuntu -- jellyfin
