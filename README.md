# Docker for a Aska dedicated server

![Static Badge](https://img.shields.io/badge/GitHub-aska--dedicated--server-blue?logo=github) [![Docker Hub](https://img.shields.io/badge/Docker_Hub-aska--dedicated--server-blue?logo=docker)](https://hub.docker.com/r/struppinet/aska-dedicated-server)

## Table of contents

- [Requirements](#requirements)
- [Info](#info)
- [Known issues](#known-issues)
- [Docker Run command](#docker-run)
- [Docker Compose command](#docker-compose)
- [Environment variables server settings](#environment-variables-server-settings)
- [Links](#links)
  
This is a Docker container to help you get started with hosting your own [Aska](https://playaska.com/) dedicated server.

## Requirements

- You need to create the authentication token for AppId `1898300` from the [Steam Manage-Game-Servers](https://steamcommunity.com/dev/managegameservers) site.

## Info

- Forked from [luxusburg/aska-server](https://github.com/luxusburg/aska-server), thanks for your work!
- This image uses the pterodactyl/wine yolk [Ptero-Eggs](https://github.com/ptero-eggs/) as it was the only thing working. Thank you guys for your work!
- The volume paths are not that great since it uses the windows emulation. 
- If anything is wrong with the config the Aska server will just crash.

| Volume   | Path                                                                                               | Description                                                                                             |
|----------|----------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------|
| savegame | /home/container/.wine/drive_c/users/container/AppData/LocalLow/Sand Sailor Studio/Aska/data/server | The path where the start-script will store the config and Aska will store the savegame                  |
| server   | /home/container/server_files                                                                       | The path where steam will install the Aska dedicated server (optional to store to avoid re-downloading) |

## Known issues

As often discussed in the official discord server: [#dedicated-server-megathread](https://discord.com/channels/1037653986368569344/1310695831854125066)

- Server quits/disconnects after a few minutes without any players.
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
    -e ASKA_AUTHENTICATION_TOKEN=${ASKA_AUTHENTICATION_TOKEN:? Please get a token at https://steamcommunity.com/dev/managegameservers with AppId 1898300} \
    -e ASKA_SERVER_NAME="Aska docker" \
    -e ASKA_DISPLAY_NAME="Aska Docker" \
    -e ASKA_PASSWORD="${ASKA_PASSWORD:? You should really set a password}" \
    -e ASKA_REGION=europe \
    -e ASKA_KEEP_SERVER_WORLD_ALIVE=false \
    struppinet/aska-dedicated-server:latest
```

## Docker Compose

```yml
services:
  aska:
    container_name: aska
    image: struppinet/aska-dedicated-server:latest
    environment:
      - ASKA_AUTHENTICATION_TOKEN=${ASKA_AUTHENTICATION_TOKEN:? Please get a token at https://steamcommunity.com/dev/managegameservers with AppId 1898300}
      - ASKA_SERVER_NAME=Aska_docker
      - ASKA_DISPLAY_NAME=Aska Docker
      - ASKA_PASSWORD=${ASKA_PASSWORD:? You should really set a password}
      - ASKA_REGION=europe
      - ASKA_KEEP_SERVER_WORLD_ALIVE=false
    volumes:
      - './savegame:/home/container/.wine/drive_c/users/container/AppData/LocalLow/Sand Sailor Studio/Aska/data/server:rw'
      - './server:/home/container/server_files:rw'
    ports:
      - '27015:27015/udp'
      - '27016:27016/udp'
    restart: unless-stopped
```

## Environment variables server settings

### Steam Options
| Variable          | Default | Description                                 |
|-------------------|---------|---------------------------------------------|
| NO_VALIDATE       | false   | Set to true to skip validation of game files |


### Game Options (ASKA_*)

You can use `ASKA_` prefixed environment variables to set any config option. The variable name is converted automatically:
- Drop the `ASKA_` prefix
- Convert to lowercase
- Replace `_` with spaces

For example: `ASKA_MONSTER_DENSITY=high` becomes `monster density = high`

Available options as of 1/22/2026:

| Variable                      | Config Key                | Default         | Options / Description                                                                                     |
|-------------------------------|---------------------------|-----------------|-----------------------------------------------------------------------------------------------------------|
| ASKA_SAVE_ID                  | save id                   |                 | Savegame ID to load (searched in server folder)                                                           |
| ASKA_DISPLAY_NAME             | display name              | Default Session | Session name displayed in the server list                                                                 |
| ASKA_SERVER_NAME              | server name               | My Aska Server  | Host name displayed in the server list                                                                    |
| ASKA_SEED                     | seed                      |                 | Seed for new save generation                                                                              |
| ASKA_PASSWORD                 | password                  |                 | Server password                                                                                           |
| ASKA_STEAM_GAME_PORT          | steam game port           | 27015           | Port for gameplay connections                                                                             |
| ASKA_STEAM_QUERY_PORT         | steam query port          | 27016           | Port for server browser queries                                                                           |
| ASKA_AUTHENTICATION_TOKEN     | authentication token      |                 | Token from https://steamcommunity.com/dev/managegameservers (AppId 1898300)                               |
| ASKA_REGION                   | region                    | default         | default, asia, japan, europe, south america, south korea, usa east, usa west, australia, canada east, hong kong, india, turkey, united arab emirates, usa south central |
| ASKA_KEEP_SERVER_WORLD_ALIVE  | keep server world alive   | false           | true/false - Keep world updating without players                                                          |
| ASKA_AUTOSAVE_STYLE           | autosave style            | every morning   | every morning, disabled, every 5 minutes, every 10 minutes, every 15 minutes, every 20 minutes           |
| ASKA_MODE                     | mode                      | normal          | normal, custom (custom enables options below)                                                             |
| ASKA_TERRAIN_ASPECT           | terrain aspect            | normal          | smooth, normal, rocky (custom mode only)                                                                  |
| ASKA_TERRAIN_HEIGHT           | terrain height            | normal          | flat, normal, varied (custom mode only)                                                                   |
| ASKA_STARTING_SEASON          | starting season           | spring          | spring, summer, autumn, winter (custom mode only)                                                         |
| ASKA_YEAR_LENGTH              | year length               | default         | minimum, reduced, default, extended, maximum (custom mode only)                                           |
| ASKA_PRECIPITATION            | precipitation             | 3               | 0 (sunny) to 6 (soggy) (custom mode only)                                                                 |
| ASKA_DAY_LENGTH               | day length                | default         | minimum, reduced, default, extended, maximum (custom mode only)                                           |
| ASKA_STRUCTURE_DECAY          | structure decay           | medium          | low, medium, high (custom mode only)                                                                      |
| ASKA_CLOTHING_DECAY           | clothing decay            | medium          | low, medium, high (custom mode only)                                                                      |
| ASKA_INVASION_DIFICULTY       | invasion dificulty        | normal          | off, easy, normal, hard (custom mode only)                                                                |
| ASKA_MONSTER_DENSITY          | monster density           | medium          | off, low, medium, high (custom mode only)                                                                 |
| ASKA_MONSTER_POPULATION       | monster population        | medium          | low, medium, high (custom mode only)                                                                      |
| ASKA_WULFAR_POPULATION        | wulfar population         | medium          | low, medium, high (custom mode only)                                                                      |
| ASKA_HERBIVORE_POPULATION     | herbivore population      | medium          | low, medium, high (custom mode only)                                                                      |
| ASKA_BEAR_POPULATION          | bear population           | medium          | low, medium, high (custom mode only)                                                                      |

### Legacy config variables

These legacy environment variables are still supported and will override the auto-config variables above:

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

## Links

Github [https://github.com/struppinet/aska-dedicated-server](https://github.com/struppinet/aska-dedicated-server)  
Docker [https://hub.docker.com/r/struppinet/aska-dedicated-server](https://hub.docker.com/r/struppinet/aska-dedicated-server)
