--Uninstall the Endpoint Encryption agent in Terminal
set command to "sudo /Library/McAfee/ee/mac/uninstall"
tell application "System Events" to set terminalAlreadyRunning to exists application process "Terminal"
tell application "Terminal"
  activate
	if terminalAlreadyRunning or not (exists first window) then
		do script command -- uses new window
	else
		do script command in first window
	end if
end tell
