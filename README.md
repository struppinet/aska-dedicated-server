# Docker for a Aska dedicated server

![Static Badge](https://img.shields.io/badge/GitHub-aska--dedicated--server-blue?logo=github) [![Docker Hub](https://img.shields.io/badge/Docker_Hub-aska--dedicated--server-blue?logo=docker)](https://hub.docker.com/r/struppinet/aska-dedicated-server)

## Table of contents
- [Known issues](#known-issues)
- [Docker Run command](#docker-run)
- [Docker Compose command](#docker-compose)
- [Environment variables server settings](#environment-variables-server-settings)
  
This is a Docker container to help you get started with hosting your own [Aska](https://playaska.com/) dedicated server.

## Info

- Forked from [luxusburg/aska-server](https://github.com/luxusburg/aska-server), thanks for your work!
- This image uses the pterodactyl/wine yolk [Ptero-Eggs](https://github.com/ptero-eggs/) as it was the only thing working. Thank you guys for your work!
- You need to create the authentication token for AppId 1898300 from the [Steam Manage-Game-Servers](https://steamcommunity.com/dev/managegameservers) site.
- The volume paths are not that great since it uses the windows emulation. 
- If anything is wrong with the config the aska server will just crash.

| Volume   | Path                                                                                               | Description                                                                                             |
|----------|----------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------|
| savegame | /home/container/.wine/drive_c/users/container/AppData/LocalLow/Sand Sailor Studio/Aska/data/server | The path where the start-script will store the config and aska will store the savegame                  |
| server   | /home/container/server_files                                                                       | The path where steam will install the aska dedicated server (optional to store to avoid re-downloading) |

## Known issues
As often discussed in the official discord server: [#dedicated-server-megathread](https://discord.com/channels/1037653986368569344/1310695831854125066)

- Sever quits/disconnects after a few minutes without any players.
- Savegame id will reset and a new save will be created. (even though the old save is still there)
- Still some xvfb/wine issues. If you encounter any please report them in the issues section with logs and specs so we can have a look.

## Docker Run

```bash
docker run -d \
    --name aska \
    -p 27015:27015/udp \
    -p 27016:27016/udp \    
    -v ./savegame:"/home/container/.wine/drive_c/users/container/AppData/LocalLow/Sand Sailor Studio/Aska/data/server" \
    -v ./server:"/home/container/server_files" \
    -e AUTHENTICATION_TOKEN=https://steamcommunity.com/dev/managegameservers \
    -e SERVER_NAME="Aska docker" \
    -e REGION=europe \
    -e KEEP_WORLD_ALIVE=false \
    struppinet/aska-dedicated-server:latest
```

## Docker Compose

```yml
services:
  aska:
    container_name: aska
    image: struppinet/aska-dedicated-server:latest
    network_mode: bridge
    environment:
      - AUTHENTICATION_TOKEN=https://steamcommunity.com/dev/managegameservers
      - SERVER_NAME=Aska_docker
      - REGION=europe
      - KEEP_WORLD_ALIVE=false
    volumes:
      - './savegame:/home/container/.wine/drive_c/users/container/AppData/LocalLow/Sand Sailor Studio/Aska/data/server:rw'
      - './server:/home/container/server_files:rw'
    ports:
      - '27015:27015/udp'
      - '27016:27016/udp'
    restart: unless-stopped
```

## Environment variables server settings

You can use these environment variables for your server settings:

| Variable             | Default         | Description                                                                                                                                                                                               |
|----------------------|-----------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| AUTHENTICATION_TOKEN |                 | The token needed for an authentication for AppId 1898300. Get it here: https://steamcommunity.com/dev/managegameservers                                                                                   |
| SESSION_NAME         | Default Session | Session name that is displayed in the server list (left column)                                                                                                                                           |
| SERVER_NAME          | My Aska Server  | Host name that is displayed in the server list (right column)                                                                                                                                             |
| REGION               | default         | Leave default to ping the best region                                                                                                                                                                     |
| PASSWORD             |                 | Sets the server password.                                                                                                                                                                                 |
| SERVER_PORT          | 27015           | The port that clients will connect to for gameplay                                                                                                                                                        |
| SERVER_QUERY_PORT    | 27016           | The port that will manage server browser related duties and info                                                                                                                                          |
| KEEP_WORLD_ALIVE     | false           | If set to true when the session is open, the world is also updating, even without players, if set to false, the world loads when the first player joins and the world unloads when the last player leaves |
| AUTOSAVE_STYLE       | every morning   | The style in which the server should save, possible options: every morning, disabled, every 5 minutes, every 10 minutes, every 15 minutes, every 20 minutes                                               |
| SAVE_ID              |                 | If not empty this savegame id will be set. Use this to ensure the same savegame id after restarts to combat the known issue with savegame recreation                                                      |
| NO_VALIDATE          | false           | Set to true to skip validation of the game files on each startup                                                                                                                                          |

**More options exists in the my_server_properties.txt file please modify it in there!**

## Links
Github [https://github.com/struppinet/aska-dedicated-server](https://github.com/struppinet/aska-dedicated-server)  
Docker [https://hub.docker.com/r/struppinet/aska-dedicated-server](https://hub.docker.com/r/struppinet/aska-dedicated-server)
