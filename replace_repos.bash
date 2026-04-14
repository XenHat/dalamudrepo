#!/bin/env bash
INSTALLED_PLUGINS_LOCATION="$HOME/.xlcore/installedPlugins"
pushd "$INSTALLED_PLUGINS_LOCATION" || exit 1
# Define the new URL you want to set
NEW_URL="https://raw.githubusercontent.com/XenHat/dalamudrepo/refs/heads/main/repo.json"

for f in $(fd --type f --glob "*.json" | grep -v ".deps.json"); do
	if [[ -r "$f" ]]; then
		if ! grep -q '"InstalledFromUrl": *"\(OFFICIAL\|official\)"' "$f" && ! grep -q '"InstalledFromUrl": "https://raw.githubusercontent.com/Ottermandias/SeaOfStars/main/repo.json"' "$f"; then
			# Replace the URL using sed
			sed -i "s|\"InstalledFromUrl\": \".*\"|\"InstalledFromUrl\": \"$NEW_URL\"|" "$f"
		fi
	else
		echo "$f is not readable"
	fi
done
popd || return
