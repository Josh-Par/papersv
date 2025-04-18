#!/bin/bash
# Written by JoshP751
# Backup the server

bin_directory="--bin-dir--"
data_directory="--data-dir--"
servername="--server-name--"
backup_prefix="$data_directory/papersv/$servername/backups"

# Check if the server is running
if screen -ls | grep -q "\.$servername\s"; then
	echo "$servername is running, stop it before creating a backup"
	exit -1
fi

# Remove after backup 5
if [[ -f "$backup_prefix/$servername.5.tar" ]]; then
	rm "$backup_prefix/$servername.5.tar"
fi

# Roll backups
for i in 4 3 2 1 0; do
	if [[ -f "$backup_prefix/$servername.$i.tar.gz" ]]; then
		mv "$backup_prefix/$servername.$i.tar.gz" "$backup_prefix/$servername.$(($i + 1)).tar.gz"
	fi
done

# Create the new backup
dir=$(pwd)
cd "$data_directory/papersv/$servername"
tar -caf "$backup_prefix/$servername.0.tar.gz" config plugins world world_nether world_the_end *.json *.yml server.properties paper.jar
echo "backup created"
cd $dir
