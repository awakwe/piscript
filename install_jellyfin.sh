#!/bin/bash

# Updating Termux repo
pkg update

# Installing necessary packages
pkg install proot-distro ffmpeg -y

# Installing Ubuntu
proot-distro install ubuntu

# Logging into Ubuntu
proot-distro login ubuntu

# Updating and upgrading the packages in Ubuntu
apt update && apt upgrade -y

# Installing necessary packages
apt install sudo curl gnupg -y

# Step 3: Download the GPG signing key
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://repo.jellyfin.org/jellyfin_team.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/jellyfin.gpg

# Step 4: Add a repository configuration
cat <<EOF | sudo tee /etc/apt/sources.list.d/jellyfin.sources
Types: deb
URIs: https://repo.jellyfin.org/ubuntu
Suites: focal
Components: main
Architectures: arm64
Signed-By: /etc/apt/keyrings/jellyfin.gpg
EOF

# Step 5: Update APT repositories
sudo apt update

# Step 6: Install Jellyfin
sudo apt install jellyfin

# Creating a symbolic link for Jellyfin web client
ln -s /usr/share/jellyfin/web /usr/lib/jellyfin/bin/jellyfin-web

# Running Jellyfin
jellyfin
