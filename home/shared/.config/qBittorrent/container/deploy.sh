#!/bin/bash

podman run -d --replace --name qbittorrent-nox -p 8080:8080 -p 6881:6881 -p 6881:6881/udp  -v /home/shared:/media buonhobo/qbittorrent-nox:4.6.2
