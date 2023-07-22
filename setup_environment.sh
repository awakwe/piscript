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
