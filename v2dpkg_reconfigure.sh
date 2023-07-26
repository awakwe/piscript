#!/bin/bash

if command -v apt > /dev/null; then
    SUDO="sudo"
elif command -v pkg > /dev/null; then
    SUDO=""
else
    echo "Neither apt nor pkg found. Can't proceed."
    exit 1
fi

echo "Reconfiguring packages with dpkg..."
$SUDO dpkg --configure -a
