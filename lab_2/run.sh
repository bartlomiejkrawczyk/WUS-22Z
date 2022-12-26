#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 CONFIG_FILE" >&2
    exit 1
fi

sudo ansible-playbook deploy.yml --extra-vars "@$1" -vvv