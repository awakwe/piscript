#!/bin/bash

# Check Python version
VERSION=$(python --version 2>&1 | cut -d' ' -f2 | cut -d'.' -f1)

# If Python version is not 3, change it
if [ "$VERSION" != "3" ]; then
  echo "alias python='/usr/bin/python3'" >> ~/.bashrc
  source ~/.bashrc
fi

# Start wsdd
~/wsdd &
