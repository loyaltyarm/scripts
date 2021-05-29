#!/bin/bash

## For this simple bootstrap script, Xcode must be manually installed to /Applications first.

set -e

BREW="/usr/local/bin/brew"
USER="testuser"
WIFI_INTERFACE=`/usr/sbin/networksetup -listallhardwareports | awk '/Hardware Port: Wi-Fi/,/Ethernet/' | awk 'NR==2' | cut -d " " -f 2`

# Enable remote login via ssh
echo "Enabling ssh..."
/usr/sbin/systemsetup -setremotelogin on

# Enable screen sharing
echo "Enabling screen sharing..."
/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -activate -configure -access -off -restart -agent -privs -all -allowAccessFor -allUsers

# Set the hard disk to never sleep
echo "Disabling sleep..."
/usr/sbin/systemsetup -setharddisksleep Never

# Set the power management settings
echo "Setting power management settings..."
/usr/bin/pmset sleep 0
/usr/bin/pmset displaysleep 0
/usr/bin/pmset disksleep 0
/usr/bin/pmset womp 1 # wake on magic packet
/usr/bin/pmset powernap 0
/usr/bin/pmset autorestart 1 # autorestart on power failure

# Disable screen lock
/usr/bin/defaults write com.apple.screensaver askForPasswordDelay 1

# Disable wireless
echo "Disabling wireless..."
/usr/sbin/networksetup -setairportpower $WIFI_INTERFACE off

# Mute the sound
echo "Muting the sound..."
/usr/bin/osascript -e 'set volume output muted true'

## Start installing necessary software
# Install Homebrew
if [ -f "$BREW" ]
then
    echo "Homebrew found."
else
    echo "Homebrew not found."
    sleep 1
    echo "You need to install homebrew!"
    sleep 1
    echo "We will do that now..."
    sleep 2
    sudo -u $USER /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" \ </dev/null
fi

# Update homebrew
sudo -u $USER /usr/local/bin/brew update

# Install brew cask
sudo -u $USER /usr/local/bin/brew install caskroom/cask/brew-cask

# Install java
sudo -u $USER /usr/local/bin/brew install openjdk

# Run Xcode post installation **We should check into moving to `xcodebuild -runFirstLaunch` in Xcode 9**
sudo /usr/local/bin/xcode_postinstallation

# Reboot the machine
sudo /sbin/reboot
