#!/bin/bash

# Bypass Gatekeeper for Xcode (at your own risk!!!!)
if [[ -e "/Applications/Xcode.app" ]]; then xattr -dr com.apple.quarantine /Applications/Xcode.app
fi

# Accept license agreement
if [[ -e "/Applications/Xcode.app/Contents/Developer/usr/bin/xcodebuild" ]]; then
  /Applications/Xcode.app/Contents/Developer/usr/bin/xcodebuild -license accept
fi

# Install Mobile Device Package, first package in 'installing components' dialog when opening Xcode
if [[ -e "/Applications/Xcode.app/Contents/Resources/Packages/MobileDevice.pkg" ]]; then
  /usr/sbin/installer -dumplog -verbose -pkg "/Applications/Xcode.app/Contents/Resources/Packages/MobileDevice.pkg" -target /
fi

# Install Mobile Development Package, second package in 'installing components' dialog when opening Xcode
if [[ -e "/Applications/Xcode.app/Contents/Resources/Packages/MobileDeviceDevelopment.pkg" ]]; then
  /usr/sbin/installer -dumplog -verbose -pkg "/Applications/Xcode.app/Contents/Resources/Packages/MobileDeviceDevelopment.pkg" -target /
fi

# Install Xcode System Resources Package, third package in 'installing components' dialog when opening Xcode
if [[ -e "/Applications/Xcode.app/Contents/Resources/Packages/XcodeSystemResources.pkg" ]]; then
  /usr/sbin/installer -dumplog -verbose -pkg "/Applications/Xcode.app/Contents/Resources/Packages/XcodeSystemResources.pkg" -target /
fi

# Install Core Types Package, fourth package in 'installing components' dialog when opening Xcode
if [[ -e "/Applications/Xcode.app/Contents/Resources/Packages/CoreTypes.pkg" ]]; then
  /usr/sbin/installer -dumplog -verbose -pkg "/Applications/Xcode.app/Contents/Resources/Packages/CoreTypes.pkg" -target /
fi

# Enable usage of developer tools
sudo DevToolsSecurity -enable

# Add all users to developer group
/usr/sbin/dseditgroup -o edit -a everyone -t group _developer

# Set the Xcode version to be used
sudo xcode-select --switch /Applications/Xcode.app

exit 0
