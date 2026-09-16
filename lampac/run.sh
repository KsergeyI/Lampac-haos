#!/bin/sh

set -e

# Persistent cache
mkdir -p /data/cache
chown -R 1000:1000 /data/cache

if [ ! -L /lampac/cache ]; then
    rm -rf /lampac/cache
    ln -s /data/cache /lampac/cache
fi

# Persistent database
mkdir -p /data/database
chown -R 1000:1000 /data/database

if [ ! -L /lampac/database ]; then
    rm -rf /lampac/database
    ln -s /data/database /lampac/database
fi

# Persistent password
if [ -f /data/passwd ]; then
    cp /data/passwd /lampac/passwd
    chown 1000:1000 /lampac/passwd
fi

# Start Lampac
if [ ! -f /data/passwd ]; then
    /usr/share/dotnet/dotnet Core.dll &
    LAMPAC_PID=$!

    while [ ! -f /lampac/passwd ]; do
        sleep 1
    done

    cp /lampac/passwd /data/passwd
    chown 1000:1000 /data/passwd

    wait "$LAMPAC_PID"
else
    exec su -s /bin/sh lampac -c "/usr/share/dotnet/dotnet Core.dll"
fi
