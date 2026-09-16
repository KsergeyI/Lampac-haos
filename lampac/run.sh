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

exec su -s /bin/sh lampac -c "/usr/share/dotnet/dotnet Core.dll"
