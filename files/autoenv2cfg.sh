#!/usr/bin/env bash

APP_FILE="$savegame_files/my_server_properties.txt"

# Find all environment variables starting with ASKA_
env | grep "^ASKA_" | while IFS='=' read -r var_name var_value; do
    # Skip if empty value
    [ -z "$var_value" ] && continue

    # Drop ASKA_ prefix, lowercase, replace _ with spaces
    config_name=$(echo "${var_name#ASKA_}" | tr '[:upper:]' '[:lower:]' | tr '_' ' ')

    echo "${config_name} set to: ${var_value}"

    if grep -q "^${config_name} =" "$APP_FILE"; then
        # Key exists, update it
        sed -i "s|^${config_name} =.*|${config_name} = ${var_value}|" "$APP_FILE"
    else
        # Key not found, warn and add it
        echo "WARNING: '${config_name}' not found in config file, adding it"
        echo -ne "\n${config_name} = ${var_value}" >> "$APP_FILE"
    fi
done
