#!/bin/bash
# Location of server data and save data for docker
server_files=/home/aska/server_files

echo " "
echo "Server files location is set to : $server_files"
echo " "

mkdir -p /home/aska/steamcmd
curl -sSL -o steamcmd.tar.gz https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz
tar -xzvf steamcmd.tar.gz -C /home/aska/steamcmd
mkdir -p /home/aska/steamcmd/steamapps # Fix steamcmd disk write error when this folder is missing
steamcmd=/home/aska/steamcmd/steamcmd.sh

mkdir -p /home/aska/.steam 2>/dev/null
chmod -R 777 /home/aska/.steam 2>/dev/null
echo " "
echo "Updating Aska Dedicated Server files..."
echo " "

if [ ! -z $BETANAME ];then
    if [ ! -z $BETAPASSWORD ]; then
        echo "Using beta $BETANAME with the password $BETAPASSWORD"
        $steamcmd +@sSteamCmdForcePlatformType windows +force_install_dir "$server_files" +login anonymous +app_update "3246670 -beta $BETANAME -betapassword $BETAPASSWORD" validate +quit
    else
        echo "Using beta $BETANAME without a password!"
        $steamcmd +@sSteamCmdForcePlatformType windows +force_install_dir "$server_files" +login anonymous +app_update "3246670 -beta $BETANAME" validate +quit
    fi
else
    echo "No beta branch used."
    $steamcmd +@sSteamCmdForcePlatformType windows +force_install_dir "$server_files" +login anonymous +app_update 3246670 validate +quit
fi

echo "Checking if server properties.txt files exists and no env virables were set"
if [ ! -f "$server_files/server properties.txt" ]; then
    echo "$server_files/server properties.txt not found. Copying default file."
    cp "/home/aska/scripts/server properties.txt" "$server_files/" 2>&1
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
echo " "
echo "Cleaning possible X11 leftovers"
echo " "

cd "$server_files"
echo "Starting Aska Dedicated Server"
echo " "
echo "Launching wine Aska"
echo " "

# dedicated server guide says to use the .bat which is just this:
export SteamAppId=1898300

# RUN
wine $server_files/AskaServer.exe -nographics -batchmode -propertiesPath 'server properties.txt' 2>&1
