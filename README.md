# Docker for a Aska dedicated server
(Forked from [luxusburg/aska-server](https://github.com/luxusburg/aska-server), thanks for your work!)

[![Docker Hub](https://img.shields.io/badge/Docker_Hub-aska--dedicated--server-blue?logo=docker)](https://hub.docker.com/r/struppinet/aska-dedicated-server) [![Docker Pulls](https://img.shields.io/docker/pulls/struppinet/aska-dedicated-server)](https://hub.docker.com/r/struppinet/aska-dedicated-server) [![Image Size](https://img.shields.io/docker/image-size/struppinet/aska-dedicated-server/latest)](https://hub.docker.com/r/struppinet/aska-dedicated-server/tags)

## Table of contents
- [Docker Run command](#docker-run)
- [Docker Compose command](#docker-compose-deployment)
- [Environment variables server settings](#environment-variables-game-settings)
  
This is a Docker container to help you get started with hosting your own [Aska](https://playaska.com/) dedicated server.

## Docker Run

```bash
docker run -d \
    --name aska \
    -p 27016:27016/udp \    
    -p 27015:27015/udp \
    -v ./server:"/home/aska/server_files" \
    -v ./savegame:"/home/container/.wine/drive_c/users/container/AppData/LocalLow/Sand Sailor Studio/Aska/data/server" \
    -e SERVER_NAME="Aska docker" \
    -e SESSION_NAME="Aska docker" \
    -e REGION=Europe \
    -e PASSWORD=change_me \
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
      - SERVER_NAME=Aska docker
      - SESSION_NAME=Aska docker
      - REGION=Europe
      - PASSWORD=change_me
      - KEEP_WORLD_ALIVE=false
    volumes:
      - './server:/home/aska/server_files:rw'
      - './savegame:/home/container/.wine/drive_c/users/container/AppData/LocalLow/Sand Sailor Studio/Aska/data/server:rw'
    ports:
      - '27016:27016/udp'
      - '27015:27015/udp'
    restart: unless-stopped
```

## Environment variables server settings

You can use these environment variables for your server settings:

| Variable             | Key                                  | Description                                                                                                                                                                                               |
|----------------------|--------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| SERVER_NAME          | optional Server Name                 | Override for the host name that is displayed in the server list                                                                                                                                           |
| SESSION_NAME         | optional Session Name                | Override for the session name that is displayed in the server list                                                                                                                                        |
| PASSWORD             | optional password                    | Sets the server password.                                                                                                                                                                                 |
| SERVER_PORT          | default: 27015                       | The port that clients will connect to for gameplay                                                                                                                                                        |
| SERVER_QUERY_PORT    | default: 27016                       | The port that will manage server browser related duties and info                                                                                                                                          |
| AUTHENTICATION_TOKEN | optional                             | The token needed for an authentication without a Steam client                                                                                                                                             |
| REGION               | optional see config file for options | Leave default to ping the best region                                                                                                                                                                     |
| KEEP_WORLD_ALIVE     | default: false                       | If set to true when the session is open, the world is also updating, even without players, if set to false, the world loads when the first player joins and the world unloads when the last player leaves |
| AUTOSAVE_STYLE       | default: every morning               | The style in which the server should save, possible options: every morning, disabled, every 5 minutes, every 10 minutes, every 15 minutes, every 20 minutes                                               |
| CUSTOM_CONFIG        | optional: true of false              | Set this to true if the server should only accept you manual adapted server_properties.txt file                                                                                                           |

**More options exists in the server properties files please modify it in there!**
