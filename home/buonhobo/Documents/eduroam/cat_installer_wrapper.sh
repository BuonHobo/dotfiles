#!/bin/bash

if [ $# -ne 2 ]
then
    echo "usage: $0 <nom.cognome> <password>"
    exit 1
else
    python -m venv venv
    source venv/bin/activate
    pip install dbus-python pyopenssl
    python eduroam-linux-UdSRT-Studenti.py -u $1 -p $2 -s
fi
