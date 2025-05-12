#!/bin/bash

# Define the entries to add
HOST_ENTRIES=$(cat <<EOF

# Home Lab Entries
192.168.2.22	transmission.lab.local grafana.lab.local
192.168.2.252	webhook.lab.local
192.168.2.254	esxi.lab.local
EOF
)

# find which OS host is on
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    HOSTS_FILE="/etc/hosts"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    HOSTS_FILE="/etc/hosts"
elif [[ "$OSTYPE" == "cygwin" || "$OSTYPE" == "msys" ]]; then
    HOSTS_FILE="/c/Windows/System32/drivers/etc/hosts"
else
    echo "Unsupported OS: $OSTYPE"
    exit 1
fi

# check if entries already exist
if grep -q "transmission.lab.local" "$HOSTS_FILE"; then
    echo "Entries already exist in $HOSTS_FILE. Skipping."
# add entries if they don't
else
    echo "Adding entries to $HOSTS_FILE..."
    if [[ "$OSTYPE" == "darwin"* || "$OSTYPE" == "linux-gnu"* ]]; then
        echo "$HOST_ENTRIES" | sudo tee -a "$HOSTS_FILE" > /dev/null
    else
        echo "$HOST_ENTRIES" >> "$HOSTS_FILE"
    fi
    echo "Done."
fi
