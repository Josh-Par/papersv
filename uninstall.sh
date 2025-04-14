#!/bin/bash
# Written by JoshP751
# Unistall script for papersv

# Default values
bin_directory="--bin-dir--"
data_directory="--data-dir--"

# Confirm
while true; do
	read -r -p "Are you sure you want to delete papersv?" confirm
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
rm "$bin_directory/papersv"
rm -r "$data_directory/papersv"