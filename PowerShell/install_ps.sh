#!/bin/bash

###################################
# Prerequisites

# Update package lists
sudo apt-get update

# Install libunwind8 and libssl1.0
# Regex is used to ensure that we do not install libssl1.0-dev, as it is a variant that is not required
sudo apt-get install '^libssl1.0.[0-9]$' libunwind8 -y

###################################
# Download and extract PowerShell
VER="7.4.3"
PWSH="powershell-${VER}-linux-arm64.tar.gz"

# Grab the latest tar.gz
wget https://github.com/PowerShell/PowerShell/releases/download/v${VER}/${PWSH}

# Make folder to put powershell
rm -rf ~/powershell
mkdir ~/powershell

# Unpack the tar.gz file
tar -xvf ./${PWSH} -C ~/powershell

# Execution authority added
chmod +x ~/powershell/pwsh

# Start PowerShell
~/powershell/pwsh

