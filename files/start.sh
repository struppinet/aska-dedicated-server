#!/bin/bash

echo " "
echo "Startup"
echo " "

server_files=/srv/aska_server_files
echo "server path: $server_files"
savegame_files="/home/container/.wine/drive_c/users/container/AppData/LocalLow/Sand Sailor Studio/Aska/data/server"
echo "savegame path: $savegame_files"

echo " "
echo "Installing Steam"
echo " "

mkdir -p /srv/steamcmd
curl -sSL -o steamcmd.tar.gz https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz
tar -xzf steamcmd.tar.gz -C /srv/steamcmd
steamcmd=/srv/steamcmd/steamcmd.sh
echo "Steam ... OK"

echo " "
echo "Installing/Updating Aska Dedicated Server files..."
echo " "

$steamcmd +@sSteamCmdForcePlatformType windows +force_install_dir "$server_files" +login anonymous +app_update 3246670 validate +quit

echo " "
echo "Configuring Aska Dedicated Server ..."
echo " "

# copy original to savegame
if [ ! -f "$savegame_files/my_server_properties.txt" ]; then
  cp "$server_files/server properties.txt" "$savegame_files/my_server_properties.txt" 2>&1
fi

# update env cfg data
source /srv/scripts/env2cfg.sh

echo " "
echo "Launching Aska Dedicated Server"
echo " "

# dedicated server guide says to use the .bat which is just this:
export SteamAppId=1898300

# RUN
cd "$server_files"
xvfb-run --auto-servernum wine $server_files/AskaServer.exe -nographics -batchmode -propertiesPath '%localappdata%low\Sand Sailor Studio\Aska\data\server\my_server_properties.txt' 2>&1
