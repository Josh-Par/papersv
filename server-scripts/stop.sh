#!/bin/bash
# Written by Josh-Par
# Stop the server

bin_directory="--bin-dir--"
data_directory="--data-dir--"
servername="--server-name--"
delay="--server-delay--"
skip=""

# Check if the server is running
if ! screen -ls | grep -q "\.$servername\s"; then
	echo "$servername isn't running"
	exit -1
fi

# Print messages for delay minutes
while [[ delay -gt 0 ]]; do
	if [[ delay -gt 1 ]]; then
		# Warning
		"$data_directory/papersv/$servername/message.sh" "say Server stopping in $delay minutes..."
		echo "Stopping server in $delay minutes..."
		# Allow an interupt
		read -t 60 -n 1 -s -r skip
		if [[ $skip = "i" ]]; then
			delay=0
		fi
	fi
	if [[ delay -eq 1 ]]; then
		echo "Stopping server in 1 minute..."
		# 1 Minute warning
		"$data_directory/papersv/$servername/message.sh" "say Server stopping in 60 seconds..."
		# Allow an interupt
		read -t 30 -n 1 -s -r skip
		if [[ $skip = "i" ]]; then
			delay=0
		fi
		"$data_directory/papersv/$servername/message.sh" "say Server stopping in 30 seconds..."
		# Allow an interupt
		read -t 20 -n 1 -s -r skip
		if [[ $skip = "i" ]]; then
			delay=0
		fi
		"$data_directory/papersv/$servername/message.sh" "say Server stopping in 10 seconds..."
		# Allow an interupt
		read -t 5 -n 1 -s -r skip
		if [[ $skip = "i" ]]; then
			delay=0
		fi
		"$data_directory/papersv/$servername/message.sh" "say Server stopping in 5 seconds..."
		# Allow an interupt
		read -t 1 -n 1 -s -r skip
		if [[ $skip = "i" ]]; then
			delay=0
		fi
		"$data_directory/papersv/$servername/message.sh" "say Server stopping in 4 seconds..."
		# Allow an interupt
		read -t 1 -n 1 -s -r skip
		if [[ $skip = "i" ]]; then
			delay=0
		fi
		"$data_directory/papersv/$servername/message.sh" "say Server stopping in 3 seconds..."
		# Allow an interupt
		read -t 1 -n 1 -s -r skip
		if [[ $skip = "i" ]]; then
			delay=0
		fi
		"$data_directory/papersv/$servername/message.sh" "say Server stopping in 2 seconds..."
		# Allow an interupt
		read -t 1 -n 1 -s -r skip
		if [[ $skip = "i" ]]; then
			delay=0
		fi
		"$data_directory/papersv/$servername/message.sh" "say Server stopping in 1 seconds..."
		# Allow an interupt
		read -t 1 -n 1 -s -r skip
		if [[ $skip = "i" ]]; then
			delay=0
		fi
	fi
	delay=$(($delay - 1))
done

echo "Stopping the server"
# Actually stop the server
"$data_directory/papersv/$servername/message.sh" "stop"

# Give 20 seconds to allow the server to stop
checks=0
while [[ checks -lt 20 ]]; do
	if ! screen -ls | grep -q "\.$servername\s"; then
		break
	fi
	checks=$(($checks + 1))
	sleep 1
done

# Force quit
if screen -ls | grep -q "\.$servername\s"; then
	echo "Servers still running, force quitting..."
	screen -rd "$servername" -X quit
fi
