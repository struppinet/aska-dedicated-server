#!/bin/bash

# Location of server data and save data for docker
server_files=/srv/aska_server_files

echo " "
echo "Server files location is set to : $server_files"
echo " "

## install steam
mkdir -p /srv/steamcmd
curl -sSL -o steamcmd.tar.gz https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz
tar -xzvf steamcmd.tar.gz -C /srv/steamcmd
steamcmd=/srv/steamcmd/steamcmd.sh

echo " "
echo "Updating Aska Dedicated Server files..."
echo " "

$steamcmd +@sSteamCmdForcePlatformType windows +force_install_dir "$server_files" +login anonymous +app_update 3246670 validate +quit

echo "Checking if server properties.txt files exists and no env virables were set"
if [ ! -f "$server_files/server properties.txt" ]; then
    echo "$server_files/server properties.txt not found. Copying default file."
    cp "/srv/scripts/server properties.txt" "$server_files/" 2>&1
fi
echo " "

echo "Checking if CUSTOM_CONFIG env is set and if set to true:"
if [ ! -z $CUSTOM_CONFIG ]; then
    if [ $CUSTOM_CONFIG = true ];then
	    echo "Not changing app.cfg file"
	else
	    echo "Running setup script for the server properties.txt file"
            source ./scripts/env2cfg.sh
	fi
else
    echo "Running setup script for the server properties.txt file"
    source ./scripts/env2cfg.sh
fi

cd "$server_files"
echo "Starting Aska Dedicated Server"
echo " "
echo "Launching wine Aska"
echo " "

# dedicated server guide says to use the .bat which is just this:
export SteamAppId=1898300

# RUN
xvfb-run --auto-servernum wine $server_files/AskaServer.exe -nographics -batchmode -propertiesPath 'server properties.txt' 2>&1
