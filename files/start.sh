#!/bin/bash

echo " "
echo "Startup"
echo " "

# reset log file
touch /tmp/app.stdout
cat /dev/null > /tmp/app.stdout

server_files="/home/container/server_files"
echo "server path: $server_files"
savegame_files="/home/container/.wine/drive_c/users/container/AppData/LocalLow/Sand Sailor Studio/Aska/data/server"
echo "savegame path: $savegame_files"

echo " "
echo "Installing Steam"
echo " "

steam_path=/home/container/steamcmd
mkdir -p $steam_path
curl -sSL -o $steam_path/steamcmd.tar.gz https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz
tar -xzf $steam_path/steamcmd.tar.gz -C $steam_path
steamcmd=$steam_path/steamcmd.sh
echo "Steam ... OK"

echo " "
echo "Installing/Updating Aska Dedicated Server files ..."
validate_flag="validate"
if [ "$NO_VALIDATE" = "true" ]; then
  echo " ... skipping file integrity check (NO_VALIDATE=true) ..."
  validate_flag=""
fi
echo " "

$steamcmd +@sSteamCmdForcePlatformType windows +force_install_dir "$server_files" +login anonymous +app_update 3246670 $validate_flag +quit
exit_code=$?

if [ $exit_code -ne 0 ]; then
  echo " "
  echo "SteamCmd failed with exit code: $exit_code"
  echo "Try deleting the appmanifest file or clear the whole server_files (installation only)"
  echo " "
  exit
else
  echo " "
  echo "SteamCmd finished successfully (Exit Code: $exit_code)"
  echo " "
fi

echo " "
echo "Configuring Aska Dedicated Server ..."
echo " "

# copy original to savegame
if [ ! -f "$savegame_files/my_server_properties.txt" ]; then
  cp "$server_files/server properties.txt" "$savegame_files/my_server_properties.txt" 2>&1
fi

# update env cfg data (auto first, then explicit mappings take priority)
source /home/container/scripts/autoenv2cfg.sh
source /home/container/scripts/env2cfg.sh

echo " "
echo "Launching Aska Dedicated Server"
echo " "

# dedicated server guide says to use the .bat which is just this:
export SteamAppId=1898300

# RUN
cd "$server_files"
xvfb-run --auto-servernum wine $server_files/AskaServer.exe -nographics -batchmode -propertiesPath 'C:/users/container/AppData/LocalLow/Sand Sailor Studio/Aska/data/server/my_server_properties.txt' 2>&1 | tee /tmp/app.stdout
