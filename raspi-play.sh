#!/bin/bash
git clone https://github.com/FD-/RPiPlay.git
cd RPiPlay
sudo apt-get install cmake
sudo apt-get install libavahi-compat-libdnssd-dev
sudo apt-get install libplist-dev
sudo apt-get install libssl-dev
mkdir build
cd build
cmake ..
make -j
sudo make install