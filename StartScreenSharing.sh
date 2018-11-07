#!/bin/bash

# Tomos Tyler, D8 Services 2014.
# (For Jamf, just so they know who wrote it)
# Enable Screen Sharing for a specific user account

# Enter a hardcoded Username here
LocalAccount=""

# CHECK TO SEE IF A VALUE WAS PASSED IN PARAMETER 4 AND, IF SO, ASSIGN TO "localAccount"

if [ "$4" != "" ] && [ "$pathToProfile" == "" ]; then
	LocalAccount=$4
fi

#Lets Turn off Screen Sharing
launchctl unload /System/Library/LaunchDaemons/com.apple.screensharing.plist 

# remove the existing ScreenSharing access group (revert to all user access)
dseditgroup -o delete -t group com.apple.access_screensharing

# Re-Create and add the users
dseditgroup -o create -q com.apple.access_screensharing

# Add Users
dseditgroup -o edit -a _jadmin -t user com.apple.access_screensharing
dseditgroup -o edit -a $LocalAccount -t user com.apple.access_screensharing

# Set the Prefs
defaults write /var/db/launchd.db/com.apple.launchd/overrides.plist com.apple.screensharing -dict Disabled -bool false
launchctl enable system/com.apple.screensharing

# Start Screen Sharing
launchctl load /System/Library/LaunchDaemons/com.apple.screensharing.plist 
