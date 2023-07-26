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

echo "Cleanup system with apt clean..."
$SUDO $PKG_MANAGER clean

echo "Updating again..."
$SUDO $PKG_MANAGER update
