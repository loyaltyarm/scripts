# Script to gather machine information into 
# a file to be exported from the machine
# to mac admins
#
#
# Created in absence of client management
# to send machine information via email
# formats email with machine name in subject line
#
#
# Info is exported into text file, see 'man system_profiler'
# to adjust reporting level or export as .plist

#!/bin/bash

# Set machine name as variable
machineName=$(scutil --get ComputerName)

# Run the command
/usr/sbin/system_profiler -detailLevel basic > /usr/local/$machineName.txt

# Send the file via email
macDiag=/usr/local/$machineName.txt
echo "Subject: MacDiagInfo from $machineName" | cat - $macDiag | /usr/sbin/sendmail -f apple_orchard@yourcompany.com -t admin@yourcompany.com

exit 0