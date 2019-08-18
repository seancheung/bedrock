#!/bin/bash
set -e

config_files=( 'server.properties' 'permissions.json' 'whitelist.json' )

if [ ! -f '/var/bedrock/.version' ] && [ -z "$MC_SKIP_DOWNLOAD" ]; then
    mkdir -p /var/bedrock
    echo "=== fetching latest bedrock-server archive info ==="
    file_url=$(curl -sL https://www.minecraft.net/en-us/download/server/bedrock | grep -Eo '(http|https)://[^\"]+bin-linux[^\"]+')
    version_number=$(echo "$file_url" | grep -oP '(?<=-)([0-9]+\.?)+' | sed 's/\.$//')
    echo "=== downloading $version_number from '$file_url' ==="
    curl -sL --progress-bar -o /tmp/bedrock.zip "$file_url"
    echo "=== extracting archive ==="
    unzip -qd /var/bedrock /tmp/bedrock.zip
    rm /tmp/bedrock.zip
    for f in "${config_files[@]}"; do
        mv -f "/var/bedrock/$f" "/var/bedrock/$f.default"
    done
    echo "$version_number" > /var/bedrock/.version
fi

mkdir -p /data/worlds
if [ ! -e '/var/bedrock/worlds' ]; then
    ln -s /data/worlds /var/bedrock/worlds
fi

for f in "${config_files[@]}"; do
	if [ ! -f "/data/$f" ]; then
        cp "/var/bedrock/$f.default" "/data/$f"
    fi
    if [ ! -f "/var/bedrock/$f" ]; then
        ln -s "/data/$f" "/var/bedrock/$f"
    fi
done

exec "$@"