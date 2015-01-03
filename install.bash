#!/bin/bash

version_component() {
  printf "%s" "$1" |
    sed -e "s/\./"$'\t'"/g" -e "s/-/"$'\t'"/" |
    cut -f "$2"
}

MAC_OS_VERSION="$(sw_vers -productVersion)"
MAC_OS_MINOR_VERSION="$(version_component "$MAC_OS_VERSION" 2)"

sudo launchctl stop com.boot2pocketmine.plexserverd
sudo launchctl unload /Library/LaunchDaemons/com.boot2pocketmine.pocketmined.plist

cp -f com.boot2pocketmine.pocketmined.plist /Library/LaunchDaemons
chown root:wheel /Library/LaunchDaemons/com.boot2pocketmine.pocketmined.plist
chmod 644 /Library/LaunchDaemons/com.boot2pocketmine.pocketmined.plist

if [ "$MAC_OS_MINOR_VERSION" -ge 10 ]; then
	sudo launchctl bootstrap system /Library/LaunchDaemons/com.boot2pocketmine.pocketmined.plist
	sudo launchctl enable system/com.boot2pocketmine.pocketmined
	sudo launchctl kickstart -k system/com.boot2pocketmine.pocketmined
else
	launchctl load -w /Library/LaunchDaemons/com.boot2pocketmine.pocketmined.plist
	launchctl start com.boot2pocketmine.pocketmined
fi
