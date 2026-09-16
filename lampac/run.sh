#!/bin/sh

chown -R 1000:1000 /lampac/data

exec /usr/share/dotnet/dotnet Core.dll
