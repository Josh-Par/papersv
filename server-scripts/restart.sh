#!/bin/bash
# Written by JoshP751
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
		"$data_directory/papersv/$servername/message.sh" "say Server restarting in $delay minutes..."
		echo "Restarting server in $delay minutes..."
		# Allow an interupt
		read -t 60 -n 1 -s -r skip
		if [[ $skip = "i" ]]; then
			delay=0
		fi
	fi
	if [[ delay -eq 1 ]]; then
		echo "Restarting server in 1 minute..."
		# 1 Minute warning
		"$data_directory/papersv/$servername/message.sh" "say Server restarting in 60 seconds..."
		# Allow an interupt
		read -t 30 -n 1 -s -r skip
		if [[ $skip = "i" ]]; then
			delay=0
		fi
		"$data_directory/papersv/$servername/message.sh" "say Server restarting in 30 seconds..."
		# Allow an interupt
		read -t 20 -n 1 -s -r skip
		if [[ $skip = "i" ]]; then
			delay=0
		fi
		"$data_directory/papersv/$servername/message.sh" "say Server restarting in 10 seconds..."
		# Allow an interupt
		read -t 5 -n 1 -s -r skip
		if [[ $skip = "i" ]]; then
			delay=0
		fi
		"$data_directory/papersv/$servername/message.sh" "say Server restarting in 5 seconds..."
		# Allow an interupt
		read -t 1 -n 1 -s -r skip
		if [[ $skip = "i" ]]; then
			delay=0
		fi
		"$data_directory/papersv/$servername/message.sh" "say Server restarting in 4 seconds..."
		# Allow an interupt
		read -t 1 -n 1 -s -r skip
		if [[ $skip = "i" ]]; then
			delay=0
		fi
		"$data_directory/papersv/$servername/message.sh" "say Server restarting in 3 seconds..."
		# Allow an interupt
		read -t 1 -n 1 -s -r skip
		if [[ $skip = "i" ]]; then
			delay=0
		fi
		"$data_directory/papersv/$servername/message.sh" "say Server restarting in 2 seconds..."
		# Allow an interupt
		read -t 1 -n 1 -s -r skip
		if [[ $skip = "i" ]]; then
			delay=0
		fi
		"$data_directory/papersv/$servername/message.sh" "say Server restarting in 1 seconds..."
		# Allow an interupt
		read -t 1 -n 1 -s -r skip
		if [[ $skip = "i" ]]; then
			delay=0
		fi
		echo "Restarting the server"
		# Stop the server
		"$data_directory/papersv/$servername/message.sh" "stop"
	fi
	delay=$(($delay - 1))
done

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

# Start the server
"$data_directory/papersv/$servername/start.sh"