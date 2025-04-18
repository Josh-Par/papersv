# PAPERSV
## Description
Papersv is a set of Linux command utilites for managing PaperMC servers.
## Install
### Copy-Install
Clone the git repository, then run `./setup.sh`  
``` bash
git clone https://github.com/JoshP751/papersv
cd papersv
./setup.sh
```
### Net-Install
Download `setup.sh` and run it  
``` bash
wget https://raw.githubusercontent.com/JoshP751/papersv/refs/heads/main/setup.sh
./setup.sh
```
### Configuring Setup.sh
setup.sh has a number of options to modify the installition of papersv, these are  
`--bin <dir>` sets the location of the papersv main script (default is /usr/bin)  
`--data <dir>` sets the location of the papersv 'data' which includes subscripts, servers, and anything else needed by papersv (default is /usr/share; a folder is created in this directory called papersv)  
`--version <version>` or `-v <version>` set the minecraft version to use (papersv defaults to the most recent paper compatible version)
`--build <build>` or `-b <build>` can be used to set the papermc build (if that level of percision is necessary; again these default to the most recent build)
### Issues with Setup.sh
If setup.sh has an issue with `sed` try running it with the `--bsd` option.
## Creating a server
To create a server run the papersv create command `papersv create $name`  
If you wish to add plugins to the server you can use either  
`papersv create $name --plugin $link1 --plugin $link2 ...`  
 -or-  
`papersv plugin $name $link1 $link2 ...`  
The only way to modify server properties is still to go to the server and modify the relavent files. The server will be in the provided data directory (or /usr/share if none was provided) in 'papersv' and in the folder of the same name. (*data directory* --> papersv --> *server name* --> *files*)
### Configuring the server creation
The create command has several options allowing the modification of a few of the servers properties, these are  
`-r <memory>` or `--ram <memory>` sets the amount of RAM available to the server (default is 4G), extensions such as M and G are permitted  
`-d <delay>` or `--delay <delay>` sets the stop / restart delay in minutes  
`--aikar` uses Aikars set of java optimization flags  
### Issues with server creation
Similiar to setup.sh if the create command has an issue with `sed` try running it with the `--bsd` option
## Starting, stopping, and restarting
Starting a server is done with `papersv start $name`.  
Restart a server is done with `papersv restart $name`.  
Stopping a server is done with `papersv stop $name`.
When stopping or restarting the server the players are given a countdown, this can be interupted by pressing *i*.
### Notes
* A backup is created everytime 
## Updating
### Updating a server
To update a server run `papersv update $name [--plugin $link] [--paper --version $version --build $build]`.  
The version and build may be omitted when updating paper, when this is done the most recent version and build are choosen.
### Updating paper
When I say 'updating paper' I mean 'updating the default version of paper', anyways this is done with the command `papersv update default [--version $version] [--build $build]`.
### Updating papersv
To update papersv run `papersv update papersv`.  
This will always update papersv to the most recent version avialable.  
## Uninstalling papersv or removing a server
### Removing a server
To remove a server run `papersv remove $name`.  
This will prompt you to confirm the deletion before it actually does anything, there is no way around this.
### Uninstall papersv
To uninstall papersv run `papersv uninstall`.  
This will (like with removing a server) prompt you to confirm the deletion before it actually does anything, there is no way around this.