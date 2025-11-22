#!/bin/bash

APP_FILE="$server_files/server properties.txt"

variables=(
    "SESSION_NAME" "session name"
    "SERVER_NAME" "server name"
    "PASSWORD" "password"
    "SERVER_PORT" "steam game port"
    "SERVER_QUERY_PORT" "steam query port"
    "AUTHENTICATION_TOKEN" "authentication token"
    "REGION" "region"
    "KEEP_WORLD_ALIVE" "keep server world alive"
    "AUTOSAVE_STYLE" "autosave style"    
)

for ((i=0; i<${#variables[@]}; i+=2)); do
    var_name=${variables[$i]}
    config_name=${variables[$i+1]}

    if [ ! -z "${!var_name}" ]; then
        echo "${config_name} set to: ${!var_name}"
        if grep -q "$config_name" "$APP_FILE"; then
            sed -i "/$config_name = /c $config_name = ${!var_name}" "$APP_FILE"
        else
            echo -ne "\n$config_name = ${!var_name}" >> "$APP_FILE"
        fi
    fi
done
