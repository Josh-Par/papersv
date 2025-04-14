#!/bin/bash
# Written by JoshP751
# Open the view screen for the server

bin_directory="--bin-dir--"
data_directory="--data-dir--"
servername="--server-name--"

# Check if the server is running
if ! screen -ls | grep -q "\.$servername\s"; then
	echo "$servername isn't running"
	exit -1
fi

# Open the screen
screen -r "$servername"