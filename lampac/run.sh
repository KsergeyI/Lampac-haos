#!/bin/sh

set -e

# Init.conf from Add-on configuration
if [ -n "$(jq -r '.init_conf // empty' /data/options.json)" ]; then
    jq -r '.init_conf' /data/options.json > /config/init.conf
fi

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

# Persistent TorrServer data
mkdir -p /data/ts
chown -R 1000:1000 /data/ts

if [ ! -L /lampac/data/ts ]; then
    rm -rf /lampac/data/ts
    ln -s /data/ts /lampac/data/ts
fi

# Persistent mods
mkdir -p /data/mods
chown -R 1000:1000 /data/mods

if [ ! -L /lampac/mods ]; then
    rm -rf /lampac/mods
    ln -s /data/mods /lampac/mods
fi

# Persistent lampainit.js
mkdir -p /data/plugins
chown 1000:1000 /data/plugins

mkdir -p /lampac/plugins/override

if [ -f /data/plugins/lampainit.js ]; then
    cp /data/plugins/lampainit.js /lampac/plugins/override/lampainit.js
fi

# Persistent passwd
if [ -f /data/passwd ]; then
    cp /data/passwd /lampac/passwd
fi

# Persistent init.conf
if [ ! -f /config/init.conf ]; then
    cat > /config/init.conf << 'EOF'
{
  "BaseModule": {
    "LoadModules": [".*"],
    "SkipModules": [
      "Catalog",
      "Tracks",
      "Transcoding",
      "WebLog",
      "CacheMedia",
      "ForkPlayerXML",
      "MsxNative",
      "Potok",
      "TelegramAuth",
      "TelegramAuthBot",
      "DLNA",
      "Rezka",
      "Alloha",
      "Filmix",
      "GetsTV",
      "IptvOnline",
      "KinoPub",
      "SakhTV",
      "VoKino",
      "iRemux",
      "PidTor",
      "CubProxy",
      "TmdbProxy",
      "OnlineGEO",
      "OnlineUKR",
      "OnlineENG",
      "OnlineAnime"
    ]
  },
  "TorrServer": {
    "releases": "latest"
  },
  "listen": {
    "localhost": "127.0.0.1"
  },
  "LampaWeb": {
    "customPlugins": [
      {
        "url": "{localhost}/sync/js/home",
        "status": 1
      }
    ],
    "initPlugins": {
      "sync": false,
      "bookmark": false,
      "timecode": false,
      "CubProxy": false,
      "TmdbProxy": false
    }
  }
}
EOF
    chown 1000:1000 /config/init.conf
fi

cp /config/init.conf /lampac/init.conf

# Fix ownership
chown 1000:1000 /lampac/passwd 2>/dev/null || true
chown 1000:1000 /lampac/init.conf 2>/dev/null || true

# Save passwd created by Lampac
(
    while [ ! -f /lampac/passwd ]; do
        sleep 1
    done

    if [ ! -f /data/passwd ]; then
        cp /lampac/passwd /data/passwd
        chown 1000:1000 /data/passwd
    fi
) &

# Start Lampac as lampac user
exec su -s /bin/sh lampac -c "/usr/share/dotnet/dotnet Core.dll"
