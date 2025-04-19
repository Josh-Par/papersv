#!/bin/bash
# Written by JoshP751
# Creates a new server

bin_directory="--bin-dir--"
data_directory="--data-dir--"
servername=""
java=""
paper=""
plugins=()
ram="4G"
for_bsd=0
delay=5
backups=5
create_full_backups=1

# Functions
# Copy a file and replace currently known --*-- values
function copy_file() {
	cp "$1" "$1-tmp"
	if [[ $for_bsd -eq 0 ]]; then
		sed -i -e "s#--bin-dir--#$bin_directory#" "$1-tmp"
		sed -i -e "s#--data-dir--#$data_directory#" "$1-tmp"
		sed -i -e "s#--java-opts--#$java#" "$1-tmp"
		sed -i -e "s#--paper-opts--#$paper#" "$1-tmp"
		sed -i -e "s#--server-name--#$servername#" "$1-tmp"
		sed -i -e "s#--server-delay--#$delay#" "$1-tmp"
		sed -i -e "s#--num-backups--#$backups#" "$1-tmp"
		sed -i -e "s#--create-full-count--#$create_full_backups#" "$1-tmp"
	else
		sed -i '' -e "s#--bin-dir--#$bin_directory#" "$1-tmp"
		sed -i '' -e "s#--data-dir--#$data_directory#" "$1-tmp"
		sed -i '' -e "s#--java-opts--#$java#" "$1-tmp"
		sed -i '' -e "s#--paper-opts--#$paper#" "$1-tmp"
		sed -i '' -e "s#--server-name--#$servername#" "$1-tmp"
		sed -i '' -e "s#--server-delay--#$delay#" "$1-tmp"
		sed -i '' -e "s#--num-backups--#$backups#" "$1-tmp"
		sed -i '' -e "s#--create-full-count--#$create_full_backups#" "$1-tmp"
	fi
	cp "$1-tmp" "$2"
	rm "$1-tmp"
}

# Argument processing
while [[ $# -gt 0 ]]; do
	case $1 in
		# The paper version information
		-v|--version)
			IFS=":"
			read paper_version paper_build <<< "$2"
			unset IFS
			shift
			shift
			;;
		# An optional java argument
		-j|--java)
			java+="\\ $2"
			shift
			shift
			;;
		# An optional paper argument
		-p|--paper)
			paper+="\\ $2"
			shift
			shift
			;;
		# The amount of ram
		-r|--ram)
			ram="$2"
			shift
			shift
			;;
		# Delay in minutes
		-d|--delay)
			delay=$2
			shift
			shift
			;;
		# Running on a BSD system
		--bsd)
			for_bsd=1
			shift
			;;
		# Add a plugin
		--plugin)
			plugins+=("$2")
			shift
			shift
			;;
		# Use Aikars flags
		--aikar)
			java+="-XX:+AlwaysPreTouch\\ -XX:+DisableExplicitGC\\ -XX:+ParallelRefProcEnabled\\ -XX:+PerfDisableSharedMem\\ -XX:+UnlockExperimentalVMOptions\\ -XX:+UseG1GC\\ -XX:G1HeapRegionSize=8M\\ -XX:G1HeapWastePercent=5\\ -XX:G1MaxNewSizePercent=40\\ -XX:G1MixedGCCountTarget=4\\ -XX:G1MixedGCLiveThresholdPercent=90\\ -XX:G1NewSizePercent=30\\ -XX:G1RSetUpdatingPauseTimePercent=5\\ -XX:G1ReservePercent=20\\ -XX:InitiatingHeapOccupancyPercent=15\\ -XX:MaxGCPauseMillis=200\\ -XX:MaxTenuringThreshold=1\\ -XX:SurvivorRatio=32\\ -Dusing.aikars.flags=https://mcflags.emc.gs\\ -Daikars.new.flags=true"
			shift
			;;
		# Set the number of backups
		-b|--backups)
			backups=$2
			shift
			shift
			;;
		# Set the number of full backups
		-f|--full)
			if [[ $2 -le $backups ]]; then
				echo "The number of full backups can't exceed the number of backups, ignoring option $1 $2"
			else
				create_full_backups=$2
			fi
			shift
			shift
			;;
		# Unknown option
		-*|--*)
			echo "Unknown option $1, type -h or --help for help"
			shift
			;;
		# Positional option
		*)
			positional+=("$1")
			shift
			;;
	esac
done

set -- "${positional[@]}"
# Add the ram to the java args
java="-Xms$ram\\ -Xmx$ram\\ $java"
servername="$1"
server_path="$data_directory/papersv/$servername"

# Check if the server already exists
if [[ -d "$server_path" ]]; then
	echo "$servername already exists!"
	exit -1
fi

# Create the sub-folders
mkdir "$server_path"
mkdir "$server_path/backups"
mkdir "$server_path/plugins"
echo "Created folders for $servername"
# Download plugins
dir=$(pwd)
cd "$server_path/plugins"
for i in "${plugins[@]}"; do
	wget "$i"
done
cd $dir
echo "Downloaded plugins for $servername"
# Copy the JAR file
cp "$data_directory/papersv/default_paper.jar" "$server_path/paper.jar"
# Copy the accepted EULA
cp "$data_directory/papersv/accepted-eula.txt" "$server_path/eula.txt"
# Copy scripts
copy_file "$data_directory/papersv/server-scripts/backup.sh" "$server_path/backup.sh"
copy_file "$data_directory/papersv/server-scripts/message.sh" "$server_path/message.sh"
copy_file "$data_directory/papersv/server-scripts/open.sh" "$server_path/open.sh"
copy_file "$data_directory/papersv/server-scripts/plugin.sh" "$server_path/plugin.sh"
copy_file "$data_directory/papersv/server-scripts/restart.sh" "$server_path/restart.sh"
copy_file "$data_directory/papersv/server-scripts/stop.sh" "$server_path/stop.sh"
copy_file "$data_directory/papersv/server-scripts/start.sh" "$server_path/start.sh"
copy_file "$data_directory/papersv/server-scripts/remove.sh" "$server_path/remove.sh"
echo "Copied scripts for $servername"