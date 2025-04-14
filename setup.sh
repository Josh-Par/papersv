#!/bin/bash
# Written by JoshP751
# Creates and sets-up the paper server system

# Default values
bin_directory="/usr/bin"
data_directory="/usr/share"
paper_version="latest"
paper_build="latest" 
for_bsd=0

# Functions
# Copy a file and replace currently known --*-- values
function copy_file() {
	cp "$1" "$1-tmp"
	if [[ $for_bsd -eq 0 ]]; then
		sed -i -e "s:--bin-dir--:$bin_directory:" "$1-tmp"
		sed -i -e "s:--data-dir--:$data_directory:" "$1-tmp"
	else
		sed -i '' -e "s:--bin-dir--:$bin_directory:" "$1-tmp"
		sed -i '' -e "s:--data-dir--:$data_directory:" "$1-tmp"
	fi
	cp "$1-tmp" "$2"
	rm "$1-tmp"
}
# Download a file from the repository and replace currently known --*-- values
function download_file() {
	wget "https://github.com/JoshP751/papersv/blob/main/$1" -O "$1-tmp"
	if [[ $for_bsd -eq 0 ]]; then
		sed -i -e "s:--bin-dir--:$bin_directory:" "$1-tmp"
		sed -i -e "s:--data-dir--:$data_directory:" "$1-tmp"
	else
		sed -i '' -e "s:--bin-dir--:$bin_directory:" "$1-tmp"
		sed -i '' -e "s:--data-dir--:$data_directory:" "$1-tmp"
	fi
	cp "$1-tmp" "$2"
	rm "$1-tmp"
}

positional=()

# Argument processing
while [[ $# -gt 0 ]]; do
	case $1 in
		# The location of the binaries
		--bin)
			bin_directory="$2"
			shift
			shift
			;;
		# The location of the data
		--data)
			data_directory="$2"
			shift
			shift
			;;
		# The paper version information
		-v|--version)
			paper_version="$2"
			shift
			shift
			;;
		-b|--build)
			paper_build="$2"
			shift
			shift
			;;
		--bsd)
			for_bsd=1
			shift
			;;
		-h|--help)
			echo "Usage: setup.sh [options]"
			echo " Setup papersv"
			echo ""
			echo "options:"
			echo "  --bin <dir>              Set the binary directory"
			echo "  --data <dir>             Set the data directory"
			echo "  -v <version>"
			echo "  --version                Set the MineCraft version"
			echo "  -b <build>"
			echo "  --build <build>          Set the Paper build #"
			echo "  -bsd                     Setting up for BSD/MacOS"
			echo "  -h"
			echo "  --help                   Print this message"
			exit 0
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

if [[ $paper_version = "latest" ]]; then
	paper_version=$(curl -s https://api.papermc.io/v2/projects/paper | jq -r '.versions[-1]')
fi
if [[ $paper_build = "latest" ]]; then
	paper_build=$(curl -s https://api.papermc.io/v2/projects/paper/versions/$paper_version/builds | jq '.builds | map(select(.channel == "default") | .build) | .[-1]')
fi
if [[ $paper_build = "null" ]]; then
	paper_version=$(curl -s https://api.papermc.io/v2/projects/paper | jq -r '.versions[-2]')
	paper_build=$(curl -s https://api.papermc.io/v2/projects/paper/versions/$paper_version/builds | jq '.builds | map(select(.channel == "default") | .build) | .[-1]')
fi

echo "Setting up papersv for $paper_version:$paper_build"

# Check if papersv is already installed
if [[ -f "$bin_directory/papersv" ]]; then
	echo "Setup.sh shouldn't be ran with papersv already installed! Use papersv update to update papersv and papersv uninstall to remove!"
	exit -1
fi

# EULA prompt (UGH)
while true; do
	echo "Minecraft Java EULA, https://aka.ms/MinecraftEULA"
	read -r -p "  Accept(y/n)?" eula
	case $eula in
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
paper_download_path="https://api.papermc.io/v2/projects/paper/versions/$paper_version/builds/$paper_build/downloads/paper-$paper_version-$paper_build.jar"

# Check if local copies exist
if [[ -f papersv ]]; then
	echo "Installing papersv locally"
	# Perform a local install
	mkdir "$data_directory/papersv"
	mkdir "$data_directory/papersv/logs"
	mkdir "$data_directory/papersv/server-scripts"
	echo "Created folders"
	# Paper is always installed from the web
	wget "$paper_download_path" -O "$data_directory/papersv/default_paper.jar"
	echo "Downloaded JAR file"
	# Move files to their final places
	copy_file papersv "$bin_directory/papersv"
	copy_file "server-scripts/start.sh" "$data_directory/papersv/server-scripts/start.sh"
	copy_file "server-scripts/restart.sh" "$data_directory/papersv/server-scripts/restart.sh"
	copy_file "server-scripts/backup.sh" "$data_directory/papersv/server-scripts/backup.sh"
	copy_file "server-scripts/stop.sh" "$data_directory/papersv/server-scripts/stop.sh"
	copy_file "server-scripts/open.sh" "$data_directory/papersv/server-scripts/open.sh"
	copy_file "server-scripts/plugin.sh" "$data_directory/papersv/server-scripts/plugin.sh"
	copy_file "server-scripts/message.sh" "$data_directory/papersv/server-scripts/message.sh"
	copy_file "server-scripts/remove.sh" "$data_directory/papersv/server-scripts/remove.sh"
	copy_file "create.sh" "$data_directory/papersv/create.sh"
	copy_file "update.sh" "$data_directory/papersv/update.sh"
	copy_file "uninstall.sh" "$data_directory/papersv/uninstall.sh"
	echo "Installed files"
	# Copy the accepted EULA
	cp "accepted-eula.txt" "$data_directory/papersv/accepted-eula.txt"
else
	echo "Installing papersv from the internet (https://github.com/JoshP751/papersv)"
	# Perform an internet install
	mkdir "$data_directory/papersv"
	mkdir "$data_directory/papersv/logs"
	mkdir "$data_directory/papersv/server-scripts"
	echo "Created folders"
	# Paper is always installed from the web
	wget "$paper_download_path" -O "$data_directory/papersv/default_paper.jar"
	echo "Downloaded JAR file"
	# Download files from the web
	download_file papersv "$bin_directory/papersv"
	download_file "server-scripts/start.sh" "$data_directory/papersv/server-scripts/start.sh"
	download_file "server-scripts/restart.sh" "$data_directory/papersv/server-scripts/restart.sh"
	download_file "server-scripts/backup.sh" "$data_directory/papersv/server-scripts/backup.sh"
	download_file "server-scripts/stop.sh" "$data_directory/papersv/server-scripts/stop.sh"
	download_file "server-scripts/open.sh" "$data_directory/papersv/server-scripts/open.sh"
	download_file "server-scripts/plugin.sh" "$data_directory/papersv/server-scripts/plugin.sh"
	download_file "server-scripts/message.sh" "$data_directory/papersv/server-scripts/message.sh"
	download_file "server-scripts/remove.sh" "$data_directory/papersv/server-scripts/remove.sh"
	download_file "create.sh" "$data_directory/papersv/create.sh"
	download_file "update.sh" "$data_directory/papersv/update.sh"
	download_file "uninstall.sh" "$data_directory/papersv/uninstall.sh"
	echo "Installed files"
	# Download the accepted EULA
	wget "https://github.com/JoshP751/papersv/blob/main/accepted-eula.txt" -O "$data_directory/papersv/accepted-eula.txt"
fi
echo "papersv has been installed and set-up"