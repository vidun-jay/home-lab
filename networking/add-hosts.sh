#!/bin/bash

# Host entries
declare -a HOST_ENTRIES=(
    "192.168.2.22	transmission.lab.local"
    "192.168.2.22	grafana.lab.local"
    "192.168.2.22	radarr.lab.local"
    "192.168.2.22	sonarr.lab.local"
    "192.168.2.22	bazarr.lab.local"
    "192.168.2.252	webhook.lab.local"
    "192.168.2.254	esxi.lab.local"
)

# Find which OS host is on
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    HOSTS_FILE="/etc/hosts"
    NEEDS_SUDO=true
elif [[ "$OSTYPE" == "darwin"* ]]; then
    HOSTS_FILE="/etc/hosts"
    NEEDS_SUDO=true
elif [[ "$OSTYPE" == "cygwin" || "$OSTYPE" == "msys" ]]; then
    # Windows-native path
    HOSTS_FILE="C:/Windows/System32/drivers/etc/hosts"
    NEEDS_SUDO=false
else
    echo "Unsupported OS: $OSTYPE"
    exit 1
fi

# Normalize hosts file path
if [[ "$OSTYPE" == "cygwin" || "$OSTYPE" == "msys" ]]; then
    # Use cygpath if available, otherwise use the C: path directly
    if command -v cygpath &> /dev/null; then
        HOSTS_FILE=$(cygpath -u "$HOSTS_FILE")
    else
        HOSTS_FILE="/c/Windows/System32/drivers/etc/hosts"
    fi
fi

# Check if hosts file exists
if [[ ! -f "$HOSTS_FILE" ]]; then
    echo "Error: Hosts file not found at $HOSTS_FILE"
    exit 1
fi

# Helper function to write to hosts file
write_to_hosts() {
    local content="$1"
    if [[ "$NEEDS_SUDO" == true ]]; then
        echo "$content" | sudo tee -a "$HOSTS_FILE" > /dev/null
    else
        # Windows: Use PowerShell with elevated privileges or append directly
        echo "$content" >> "$HOSTS_FILE"
    fi
}

# Track what needs to be added
ENTRIES_TO_ADD=()
HEADER_NEEDED=false

# Check each entry individually
for entry in "${HOST_ENTRIES[@]}"; do
    # Extract IP and hostnames from the entry
    IP=$(echo "$entry" | awk '{print $1}')
    HOSTNAMES=$(echo "$entry" | awk '{$1=""; print $0}' | xargs)
    
    # Check if this exact line or any of these hostnames already exist
    ENTRY_EXISTS=false
    
    # Split hostnames and check each one
    for hostname in $HOSTNAMES; do
        if grep -qE "[[:space:]]${hostname}([[:space:]]|$)" "$HOSTS_FILE" 2>/dev/null; then
            ENTRY_EXISTS=true
            echo "✅ $hostname already exists in hosts file"
            break
        fi
    done
    
    # If none of the hostnames exist, mark entry for addition
    if [[ "$ENTRY_EXISTS" == false ]]; then
        ENTRIES_TO_ADD+=("$entry")
        echo "❌ Missing: $IP -> $HOSTNAMES"
    fi
done

# Add header check
if ! grep -q "\n# Home Lab Entries" "$HOSTS_FILE" 2>/dev/null && [[ ${#ENTRIES_TO_ADD[@]} -gt 0 ]]; then
    HEADER_NEEDED=true
fi

# Add missing entries
if [[ ${#ENTRIES_TO_ADD[@]} -eq 0 ]]; then
    echo ""
    echo "✅ All home lab entries already exist. Nothing to add."
else
    echo ""
    echo "📝 Adding ${#ENTRIES_TO_ADD[@]} missing entries to $HOSTS_FILE..."
    
    # Build the content to add
    CONTENT_TO_ADD=""
    if [[ "$HEADER_NEEDED" == true ]]; then
        CONTENT_TO_ADD=$'\n'"# Home Lab Entries"$'\n'
    fi
    
    for entry in "${ENTRIES_TO_ADD[@]}"; do
        CONTENT_TO_ADD+="$entry"$'\n'
    done
    
    # Write to hosts file
    write_to_hosts "$CONTENT_TO_ADD"
    
    echo "✅ Successfully added ${#ENTRIES_TO_ADD[@]} entries."
fi
