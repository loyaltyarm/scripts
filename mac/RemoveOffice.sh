# Script to Remove Microsoft Office 2011 for Mac
# modified slightly from officeformachelp.com
# http://www.officeformachelp.com/office/install/remove-office/
# by Nick Cobb - loyaltyarm@gmail.com

#!/bin/bash

RunAsRoot()
{
        ## Pass in the full path to the executable as $1
        if [[ "${USER}" != "root" ]] ; then
echo
echo "*** This application must be run as root. Please authenticate below. ***"
                echo
sudo "${1}" && exit 0
        fi
}

echo "Please press CTRL+C to ABORT. Office will be REMOVED in 15 seconds."
sleep 20

echo "Removing Office Applications"
echo "Removing Communicator..."
rm -R '/Applications/Microsoft Communicator.app/'
sleep 1

echo "Removing Messenger..."
rm -R '/Applications/Microsoft Messenger.app/'
sleep 1

echo "Removing Office 2011 Applications Directory and contents..."
rm -R '/Applications/Microsoft Office 2011/'
sleep 1

echo "Removing Remote Desktop..."
rm -R '/Applications/Remote Desktop Connection.app/'
sleep 1

echo "Now Removing Application Support files..."
rm -R '/Library/Application Support/Microsoft/'
sleep 1

echo "Removing Office 2011 Automator Actions..."
rm -R '/Library/Automator/*Excel*'
rm -R '/Library/Automator/*Office*'
rm -R '/Library/Automator/*Outlook*'
rm -R '/Library/Automator/*PowerPoint*'
rm -R '/Library/Automator/*Word*'
rm -R '/Library/Automator/Add New Sheet to Workbooks.action'
rm -R '/Library/Automator/Create List from Data in Workbook.action'
rm -R '/Library/Automator/Create Table from Data in Workbook.action'
rm -R '/Library/Automator/Get Parent Presentations of Slides.action'
rm -R '/Library/Automator/Get Parent Workbooks.action'
rm -R '/Library/Automator/Set Document Settings.action'
sleep 1

echo "Removing Microsoft Fonts..."
rm -R '/Library/Fonts/Microsoft/'
sleep 1

echo "Removing Office 2011 Preferences and Helpers..."
rm -R '/Library/Internet Plug-Ins/*SharePoint*'
rm -R '/Library/LaunchDaemons/*Microsoft*'
rm -R '/Library/Preferences/*Microsoft*'
rm -R '/Library/PrivilegedHelperTools/*Microsoft*'
sleep 1

echo "Removing Installer Receipts..."
OFFICERECEIPTS=$(pkgutil --pkgs=com.microsoft.office*)
for ARECEIPT in $OFFICERECEIPTS
do
	pkgutil --forget $ARECEIPT
done