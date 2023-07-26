#!/bin/bash

if command -v apt > /dev/null; then
    PKG_MANAGER="apt"
    SUDO="sudo"
elif command -v pkg > /dev/null; then
    PKG_MANAGER="pkg"
    SUDO=""
else
    echo "Neither apt nor pkg found. Can't proceed."
    exit 1
fi

echo "Updating packages list..."
$SUDO $PKG_MANAGER update --fix-missing

echo "Force installation of required packages..."
$SUDO $PKG_MANAGER install -f

echo "Fixing broken installs..."
$SUDO $PKG_MANAGER --fix-broken install

echo "Performing a full upgrade..."
$SUDO $PKG_MANAGER full-upgrade -y
