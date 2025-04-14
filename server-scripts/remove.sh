#!/bin/bash
# Written by JoshP751
# Delete the server

bin_directory="--bin-dir--"
data_directory="--data-dir--"
servername="--server-name--"

# Check if the server is running
if screen -ls | grep -q "\.$servername\s"; then
	echo "$servername is running, stop it before deleting it!"
	exit -1
fi

# Confirm
while true; do
	read -r -p "Are you sure you want to $servername?" confirm
	case $confirm in
		[yY])
			break
			;; 
		[nN])
			exit 0
			;;
		*)
			echo "Please enter y/n."
			;;
	esac
done

# Delete
rm -r "$data_directory/papersv/$servername"