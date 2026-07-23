#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TARGET_DIR=""
    if [ -d "$SCRIPT_DIR/.git" ]; then
        TARGET_DIR="$SCRIPT_DIR"
        echo "Found repository in script directory: $TARGET_DIR"
    else
        echo "Script is not in a git repository. Searching common paths..."
            POSSIBLE_PATHS=(
                "/var/www/html/tek.aevl.us"
                "/var/www/html"
                "$HOME/tek.aevl.us"
                "$HOME/html"
            )
    for dir in "${POSSIBLE_PATHS[@]}"; do
        if [ -d "$dir/.git" ]; then
                TARGET_DIR="$dir"
                echo "Found repository at: $TARGET_DIR"
                break # Stop searching once we find it
            fi
        done
    fi
if [ -z "$TARGET_DIR" ]; then
    echo "Error: Could not find the git repository."
    exit 1
fi
sudo crontab - << 'EOF'
@reboot sleep 30 && cd /var/www/html/tek.aevl.us/ && /usr/bin/git pull > /var/log/git-pull.log 2>&1
0 * * * * cd /var/www/html/tek.aevl.us/ && /usr/bin/git pull > /var/log/git-pull.log 2>&1
EOF
cd "$TARGET_DIR" || exit

sudo git fetch
sudo git pull
