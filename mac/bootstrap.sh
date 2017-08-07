#!/bin/bash

set -e

BREW="/usr/local/bin/brew"
CLIENT_IDENTIFIER="machine-bootstrap"
MUNKI_PKG="munkitools-3.0.3.3352.pkg"
MUNKI_URL="https://github.com/munki/munki/releases/download/v3.0.3/"
PACKAGING_SERVER_URL="https://munki-internal01.example.com/repo" 
PUPPET_VERSION="4.1.0"
USER="testuser"
WIFI_INTERFACE=`/usr/sbin/networksetup -listallhardwareports | awk '/Hardware Port: Wi-Fi/,/Ethernet/' | awk 'NR==2' | cut -d " " -f 2`
WORKING_DIRECTORY="/tmp/my-puppet-repo-folder"

# Download and install the munki toolchain
echo "Installing the munki tools..."
pushd /tmp
/usr/bin/curl -OL $MUNKI_URL/$MUNKI_PKG
sudo /usr/sbin/installer -pkg $MUNKI_PKG -target /
popd

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
sudo -u $USER /usr/local/bin/brew cask install java

# Set some Munki properties
echo "Setting munki properties..."
/usr/bin/defaults write /Library/Preferences/ManagedInstalls ClientIdentifier $CLIENT_IDENTIFIER
/usr/bin/defaults write /Library/Preferences/ManagedInstalls SoftwareRepoURL $PACKAGING_SERVER_URL

# Check in the machine to Munki to get initial packages that have been scoped
echo "Checking for packages..."
/usr/local/munki/managedsoftwareupdate -v --checkonly

# Install the packages that have been scoped
echo "Installing packages..."
/usr/local/munki/managedsoftwareupdate -v --installonly

## Install Puppet tooling for future management
# Install Puppet
echo "Installing Puppet..."
sudo /usr/bin/gem install -n /usr/local/bin puppet -v $PUPPET_VERSION --no-rdoc --no-ri

# Install Hiera-Eyaml tooling for future secret management
echo "Installing Hiera-Eyaml..."
sudo /usr/bin/gem install -n /usr/local/bin hiera-eyaml --no-rdoc --no-ri

# Install r10k
echo "Installing r10k..."
sudo /usr/bin/gem install -n /usr/local/bin r10k --no-document
## End install of Puppet tooling

# Install fastlane
echo "Installing fastlane..."
sudo /usr/bin/gem install -n /usr/local/bin fastlane --no-rdoc --no-ri

# Run Xcode post installation **We should check into moving to `xcodebuild -runFirstLaunch` in Xcode 9**
sudo /usr/local/bin/xcode_postinstallation

# Reboot the machine
sudo /sbin/reboot
