#!/bin/bash
# Written by JoshP751
# Print a message to the server

bin_directory="--bin-dir--"
data_directory="--data-dir--"
servername="--server-name--"

# Check if the server is running
if ! screen -ls | grep -q "\.$servername\s"; then
	echo "$servername isn't running"
	exit -1
fi

# Print everthing on the command line
echo "$* has been sent to the server"
screen -Rd "$servername" -X stuff "$* $(printf '\r')"