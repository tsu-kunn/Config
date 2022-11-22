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

# Grab the latest tar.gz
wget https://github.com/PowerShell/PowerShell/releases/download/v7.3.0/powershell-7.3.0-linux-arm64.tar.gz

# Make folder to put powershell
rm -rf ~/powershell
mkdir ~/powershell

# Unpack the tar.gz file
tar -xvf ./powershell-7.3.0-linux-arm64.tar.gz -C ~/powershell

# Execution authority added
chmod +x ~/powershell/pwsh

# Start PowerShell
~/powershell/pwsh

