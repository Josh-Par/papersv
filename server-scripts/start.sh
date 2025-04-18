#!/bin/bash
# Written by JoshP751
# Start the server

bin_directory="--bin-dir--"
data_directory="--data-dir--"
servername="--server-name--"
java_opts="--java-opts--"
paper_opts="--paper-opts--"
backup=1

positional=()

# Argument processing
while [[ $# -gt 0 ]]; do
	case $1 in
		# Positional option
		--no-backup)
			backup=0
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
	echo "$servername is already running, use screen -r $servername or papersv view $servername to view it"
	exit -1
fi

if [[ "$backup" -eq 1 ]]; then
	# Backup
	"$data_directory/papersv/$servername/backup.sh" --type create # This is an undocumented type 
	echo "backup of $servername has been created"
fi

# Start server
dir=$(pwd)
cd "$data_directory/papersv/$servername"
screen -L -Logfile "$data_directory/papersv/logs/$servername.$(date +%Y-%m-%d-%H-%M-%S).log" -dmS "$servername" /bin/bash -c "java $java_opts -jar \"$data_directory/papersv/$servername/paper.jar\" $paper_opts --nogui"
echo "$servername has been started"
cd $dir