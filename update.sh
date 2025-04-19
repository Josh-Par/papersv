#!/bin/bash
# Written by JoshP751
# Updates the specified target

bin_directory="--bin-dir--"
data_directory="--data-dir--"
paper_version=$(curl -s https://api.papermc.io/v2/projects/paper | jq -r '.versions[-1]')
paper_build=$(curl -s https://api.papermc.io/v2/projects/paper/versions/$paper_version/builds | jq '.builds | map(select(.channel == "default") | .build) | .[-1]')
positional=()
plugins=()
silence=0
for_bsd=0
update_paper=0

# Functions
# Download a file from the repository and replace currently known --*-- values
function download_file() {
	wget "https://raw.githubusercontent.com/JoshP751/papersv/refs/heads/main/$1" -O "$1-tmp"
	if [[ for_bsd -eq 0 ]]; then
		sed -i -e "s:--bin-dir--:$bin_directory:" "$1-tmp"
		sed -i -e "s:--data-dir--:$data_directory:" "$1-tmp"
	else
		sed -i '' -e "s:--bin-dir--:$bin_directory:" "$1-tmp"
		sed -i '' -e "s:--data-dir--:$data_directory:" "$1-tmp"
	fi
	cp "$1-tmp" "$2"
	rm "$1-tmp"
}

# Argument processing
while [[ $# -gt 0 ]]; do
	case $1 in
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
		--paper)
			update_paper=1
			shift
			;;
		# The plugin to update
		-p|--plugin)
			plugins+=("$2")
			shift
			shift
			;;
		--bsd)
			for_bsd=1
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

paper_download_path="https://api.papermc.io/v2/projects/paper/versions/$paper_version/builds/$paper_build/downloads/paper-$paper_version-$paper_build.jar"

case "$1" in
	# Update papersv
	papersv)
		# Download a more recent update-script
		download_file update.sh "$data_directory/papersv/update-2.sh"
		"$data_directory/papersv/update-2.sh" self
		;;
	# Stage 2 of updating papersv
	self)
		# Download all other files
		download_file papersv "$bin_directory/papersv"
		download_file "server-scripts/start.sh" "$data_directory/papersv/server-scripts/start.sh"
		download_file "server-scripts/restart.sh" "$data_directory/papersv/server-scripts/restart.sh"
		download_file "server-scripts/backup.sh" "$data_directory/papersv/server-scripts/backup.sh"
		download_file "server-scripts/stop.sh" "$data_directory/papersv/server-scripts/stop.sh"
		download_file "server-scripts/open.sh" "$data_directory/papersv/server-scripts/open.sh"
		download_file "server-scripts/plugin.sh" "$data_directory/papersv/server-scripts/plugin.sh"
		download_file "server-scripts/message.sh" "$data_directory/papersv/server-scripts/message.sh"
		download_file "create.sh" "$data_directory/papersv/create.sh"
		download_file "update.sh" "$data_directory/papersv/update.sh"
		;;
	# Update default paper
	default)
		# Update paper
		wget "$paper_download_path" -O "$data_directory/papersv/default_paper.jar"
		;;
	# Update a server
	*)
		# Create a backup
		"$data_directory/papersv/$1/backup.sh"
		# Update papersv
		download_file "server-scripts/start.sh" "$data_directory/papersv/$1/start.sh"
		download_file "server-scripts/restart.sh" "$data_directory/papersv/$1/restart.sh"
		download_file "server-scripts/backup.sh" "$data_directory/papersv/$1/backup.sh"
		download_file "server-scripts/stop.sh" "$data_directory/papersv/$1/stop.sh"
		download_file "server-scripts/open.sh" "$data_directory/papersv/$1/open.sh"
		download_file "server-scripts/plugin.sh" "$data_directory/papersv/$1/plugin.sh"
		download_file "server-scripts/message.sh" "$data_directory/papersv/$1/message.sh"
		# Update plugins
		if [[ ${#plugins[@]} -gt 0 ]]; then
			mkdir "$data_directory/papersv/$1/plugins/update"
			dir=$(pwd)
			cd "$data_directory/papersv/$1/plugins/update"
			for i in "${plugins}"; do
				wget "$i"
			done
			cd $dir
		fi
		# Update paper
		if [[ $update_paper -eq 1 ]]; then
			wget "$paper_download_path" -O "$data_directory/papersv/$1/paper.jar"
		fi
		;;
esac
