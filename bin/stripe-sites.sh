#!/usr/bin/env bash
set -euo pipefail

target="${1:?Usage: strip-sites.sh <target>}"

sites=("nest" "main")

for site in "${sites[@]}"; do
    if [[ "$target" == "$site-"* ]]; then
        target="${target#"$site"-}"
        break
    elif [[ "$target" == *-"$site" ]]; then
        target="${target%-"$site"}"
        break
    fi
done

printf '%s\n' "$target"
