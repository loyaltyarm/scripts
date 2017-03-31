# script to blank all other proxy settings and set
# the autoproxyurl for your organization
#
# script will show errors when usb ethernet and ethernet
# are both present - this was not a problem for me, but may
# be in your org
#
# written by nick cobb - loyaltyarm@gmail.com
# adopted from various sources via internet

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

RunAsRoot "${0}"

######## HARDCODED VALUES ARE SET HERE ##########
echo Setting Network Values...
pacfile="yourcompany.autoproxy.urlhere"

Eth="Ethernet"
Eth1="USB Ethernet"
Eth2="Thunderbolt Ethernet"
Wi="Wi-Fi"
#################################################

echo
echo Checking Ethernet...
sleep 1
if
networksetup -listallnetworkservices | grep "${Eth}"
then
networksetup -setgopherproxystate "${Eth}" off
networksetup -setstreamingproxystate "${Eth}" off
networksetup -setsocksfirewallproxystate "${Eth}" off
networksetup -setftpproxystate "${Eth}" off
networksetup -setsecurewebproxystate "${Eth}" off
networksetup -setwebproxystate "${Eth}" off
networksetup -setautoproxystate "${Eth}" off
networksetup -setproxyautodiscovery "${Eth}" off
networksetup -setautoproxyurl "${Eth}" "${pacfile}" | echo Ethernet Completed
else
echo "There is not a service for "${Eth}" no need to set the proxy"
fi

echo
echo Checking USB Ethernet...
sleep 1
if
networksetup -listallnetworkservices | grep "${Eth1}"
then
networksetup -setgopherproxystate "${Eth1}" off
networksetup -setstreamingproxystate "${Eth1}" off
networksetup -setsocksfirewallproxystate "${Eth1}" off
networksetup -setftpproxystate "${Eth1}" off
networksetup -setsecurewebproxystate "${Eth1}" off
networksetup -setwebproxystate "${Eth1}" off
networksetup -setautoproxystate "${Eth1}" off
networksetup -setproxyautodiscovery "${Eth1}" off
networksetup -setautoproxyurl "${Eth1}" "${pacfile}" | echo USB Ethernet Completed
else
echo "There is not a service for "${Eth1}" no need to set the proxy"
fi

echo
echo Checking Thunderbolt Ethernet...
sleep 1
if
networksetup -listallnetworkservices | grep "${Eth2}"
then
networksetup -setgopherproxystate "${Eth2}" off
networksetup -setstreamingproxystate "${Eth2}" off
networksetup -setsocksfirewallproxystate "${Eth2}" off
networksetup -setftpproxystate "${Eth2}" off
networksetup -setsecurewebproxystate "${Eth2}" off
networksetup -setwebproxystate "${Eth2}" off
networksetup -setautoproxystate "${Eth2}" off
networksetup -setproxyautodiscovery "${Eth2}" off
networksetup -setautoproxyurl "${Eth2}" "${pacfile}" | echo Ethernet Completed
else
echo "There is not a service for "${Eth2}" no need to set the proxy"
fi

echo
echo Checking Wi-Fi...
sleep 1
if
networksetup -listallnetworkservices | grep "${Wi}"
then
networksetup -setgopherproxystate "${Wi}" off
networksetup -setstreamingproxystate "${Wi}" off
networksetup -setsocksfirewallproxystate "${Wi}" off
networksetup -setftpproxystate "${Wi}" off
networksetup -setsecurewebproxystate "${Wi}" off
networksetup -setwebproxystate "${Wi}" off
networksetup -setautoproxystate "${Wi}" off
networksetup -setproxyautodiscovery "${Wi}" off
networksetup -setautoproxyurl "${Wi}" "${pacfile}" | echo Wi-Fi Completed
else
echo "There is not a service for "${Wi}" no need to set the proxy"
fi

echo Exiting...
sleep 1

exit 0
