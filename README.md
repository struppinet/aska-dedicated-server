# Docker for a Aska dedicated server
(Forked from [luxusburg/aska-server](https://github.com/luxusburg/aska-server), thanks for your work!)

[![Docker Hub](https://img.shields.io/badge/Docker_Hub-aska_dedicated_server-blue?logo=docker)](https://hub.docker.com/r/struppinet/aska-dedicated-server) [![Docker Pulls](https://img.shields.io/docker/pulls/struppinet/aska-dedicated-server)](https://hub.docker.com/r/struppinet/aska-dedicated-server) [![Image Size](https://img.shields.io/docker/image-size/struppinet/aska-dedicated-server/latest)](https://hub.docker.com/r/struppinet/aska-dedicated-server/tags)

## Table of contents
- [Docker Run command](#docker-run)
- [Docker Compose command](#docker-compose-deployment)
- [Environment variables server settings](#environment-variables-game-settings)
- [Environment variables for the User PUID/GUID](#environment-variables-for-the-user-puidguid)
- [Environemnt variables for the beta branch](#environemnt-variables-for-the-beta-branch)

This is a Docker container to help you get started with hosting your own [Aska](https://playaska.com/) dedicated server.

This Docker container has been tested and will work on the following OS:

- Linux (Ubuntu/Debian)

> [!TIP]
> Add environment variables so that you can for example change the password of the server
> On the bottom you will find a list of all environment variables to change, if you want to use your own server_properties.txt file
> set the CUSTOM_CONFIG to true

> [!IMPORTANT]
> The first server start can take a few minutes! If you are stuck in the logs on this part just be a bit more patient:

```bash
wine: created the configuration directory '/home/aska/.wine'
002c:fixme:actctx:parse_depend_manifests Could not find dependent assembly L"Microsoft.Windows.Common-Controls" (6.0.0.0)
004c:fixme:actctx:parse_depend_manifests Could not find dependent assembly L"Microsoft.Windows.Common-Controls" (6.0.0.0)
0054:fixme:actctx:parse_depend_manifests Could not find dependent assembly L"Microsoft.Windows.Common-Controls" (6.0.0.0)
0054:err:ole:StdMarshalImpl_MarshalInterface Failed to create ifstub, hr 0x80004002
0054:err:ole:CoMarshalInterface Failed to marshal the interface {6d5140c1-7436-11ce-8034-00aa006009fa}, hr 0x80004002
0054:err:ole:apartment_get_local_server_stream Failed: 0x80004002
0054:err:ole:start_rpcss Failed to open RpcSs service
004c:err:ole:StdMarshalImpl_MarshalInterface Failed to create ifstub, hr 0x80004002
004c:err:ole:CoMarshalInterface Failed to marshal the interface {6d5140c1-7436-11ce-8034-00aa006009fa}, hr 0x80004002
004c:err:ole:apartment_get_local_server_stream Failed: 0x80004002
0090:err:winediag:gnutls_process_attach failed to load libgnutls, no support for encryption
0090:err:winediag:process_attach failed to load libgnutls, no support for pfx import/export
0098:err:winediag:gnutls_process_attach failed to load libgnutls, no support for encryption
```

## Docker Run

**This will create the folders './server' and './data' in your current folder where you execute the code**

**Recommendation:**
Create a folder before executing this docker command

To deploy this docker project run:

```bash
docker run -d \
    --name aska \
    -p 27016:27016/udp \    
    -p 27015:27015/udp \
    -v ./server:/home/aska/server_files \
    -e TZ=Europe/Paris \
    -e PASSWORD=change_me
    -e SERVER_NAME='Aska docker server'
    -e KEEP_WORLD_ALIVE=false
    struppinet/aska-dedicated-server:latest
```

## Docker compose Deployment

**This will create the folders './server' and './data' in your current folder where you execute compose file**

**Recommendation:**
Create a folder before executing the docker compose file

> [!IMPORTANT]
> Older docker compose version needs this line before the **services:** line
>
> version: '3'

```yml
services:
  aska:
    container_name: aska
    image: struppinet/aska-dedicated-server:latest
    network_mode: bridge
    environment:
      - TZ=Europe/Paris
      - PASSWORD=change_me
      - SERVER_NAME='Aska docker'
      - KEEP_WORLD_ALIVE=false
    volumes:
      - './server:/home/aska/server_files:rw'
    ports:
      - '27016:27016/udp'
      - '27015:27015/udp'
    restart: unless-stopped
```

## Environment variables server settings

You can use these environment variables for your server settings:

| Variable | Key | Description |
| -------------------- | ---------------------------- | ------------------------------------------------------------------------------- |
| TZ | Europe/Paris | timezone |
| SERVER_NAME | optional Server Name | Override for the host name that is displayed in the session list |
| PASSWORD | optional password | Sets the server password. |
| SERVER_PORT | default: 27015  | The port that clients will connect to for gameplay |
| SERVER_QUERY_PORT | default: 27016 | The port that will manage server browser related duties and info  |
| AUTHENTICATION_TOKEN | optional | The token needed for an authentication without a Steam client |
| REGION | optional see config file for options | Leave default to ping the best region |
| KEEP_WORLD_ALIVE | default: false | If set to true when the session is open, the world is also updating, even without players, if set to false, the world loads when the first player joins and the world unloads when the last player leaves |
| AUTOSAVE_STYLE | default: every morning | The style in which the server should save, possible options: every morning, disabled, every 5 minutes, every 10 minutes, every 15 minutes, every 20 minutes  |
| CUSTOM_CONFIG | optional: true of false | Set this to true if the server should only accept you manual adapted server_properties.txt file |

**More options exists in the server properties files please modify it in there!**

## Environment variables for the User PUID/GUID

| Variable | Key | Description |
| -------------------- | ---------------------------- | ------------------------------------------------------------------------------- |
| PUID | default: 1000 | User ID |
| PGUID | default: 1000| Group ID |

## Environemnt variables for the beta branch

| Variable | Key | Description |
| -------------------- | ---------------------------- | ------------------------------------------------------------------------------- |
| BETANAME |  no default value| Set the beta branch name. Don't use `""` or `''`!|
| BETAPASSWORD | no default value | Set the beta branch password. Don't use `""` or `''`! |
