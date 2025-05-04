#!/bin/bash
# Written by Josh-Par
# Backup the server

bin_directory="--bin-dir--"
data_directory="--data-dir--"
servername="--server-name--"
backup_prefix="$data_directory/papersv/$servername/backups"
backup_type="full"
num_backups=--num-backups--
create_full_count=--create-full-count--

positional=()

# Argument processing
while [[ $# -gt 0 ]]; do
	case $1 in
		# Positional option
		--type)
			backup_type="$2"
			shift
			shift
			;;
		*)
			positional+=("$1")
			shift
			;;
	esac
done

set -- "${positional[@]}"

# Check if the server is running
if screen -ls | grep -q "\.$servername\s"; then
	echo "$servername is running, stop it before creating a backup"
	exit -1
fi

full_count=0

# Remove after backup 5
if [[ -f "$backup_prefix/$servername.world.$num_backups.tar.gz" ]]; then
	rm "$backup_prefix/$servername.world.$num_backups.tar.gz"
elif [[ -f "$backup_prefix/$servername.full.$num_backups.tar.gz" ]]; then
	rm "$backup_prefix/$servername.full.$num_backups.tar.gz"
fi

# Roll backups
i=$(($num_backups - 1))

while [[ $i -gt 0 ]]; do
	if [[ -f "$backup_prefix/$servername.world.$i.tar.gz" ]]; then
		mv "$backup_prefix/$servername.world.$i.tar.gz" "$backup_prefix/$servername.world.$(($i + 1)).tar.gz"
	elif [[ -f "$backup_prefix/$servername.full.$i.tar.gz" ]]; then
		mv "$backup_prefix/$servername.full.$i.tar.gz" "$backup_prefix/$servername.full.$(($i + 1)).tar.gz"
		full_count=$(($full_count + 1)) # Increment full count
	fi
	i=$(($i - 1))
done

# Check if 'backup_type' is 'create'
if [[ "$backup_type" == "create" ]]; then
	# Check if the number of full backups equals the number wanted
	if [[ $full_count -ge $create_full_count ]]; then
		backup_type="world"
	else
		backup_type="full"
	fi
fi

# Check the current type
if [[ "$backup_type" == "world" ]]; then
	# Create the new world backup
	dir=$(pwd)
	cd "$data_directory/papersv/$servername"
	tar -caf "$backup_prefix/$servername.world.1.tar.gz" world world_nether world_the_end
	echo "backup created"
	cd $dir
elif [[ "$backup_type" == "full" ]]; then
	# Create the new full backup
	dir=$(pwd)
	cd "$data_directory/papersv/$servername"
	tar -caf "$backup_prefix/$servername.full.1.tar.gz" config plugins world world_nether world_the_end *.json *.yml server.properties paper.jar
	echo "backup created"
	cd $dir
else
	echo "$backup_type is not a valid backup type"
fi
