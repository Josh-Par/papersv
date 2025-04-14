#!/bin/bash
# Written by JoshP751
# Install a plugin

bin_directory="--bin-dir--"
data_directory="--data-dir--"
servername="--server-name--"

# Check if the server is running
if screen -ls | grep -q "\.$servername\s"; then
	echo "$servername is running, stop it before installing a plugin"
	exit -1
fi

# Install the plugin
dir=$(pwd)
cd "$data_directory/papersv/$servername/plugins/"
c=0
# Download the plugins
for i in $*; do
	if [[ c -eq 1 ]]; then
		wget "$i"
	else
		c=1
	fi
done
cd "$dir"
