#!/bin/env bash
INSTALLED_PLUGINS_LOCATION="$HOME/.xlcore/installedPlugins"
# Define the new URL you want to set
NEW_URL="https://raw.githubusercontent.com/XenHat/dalamudrepo/refs/heads/main/repo.json"
IFS= read -r -d '' repolist <./repolist
pushd "$INSTALLED_PLUGINS_LOCATION" || exit 1
for d in */; do
	foldername=${d%%"/"*}
	for j in $(find . -name "${foldername}.json"); do
		file="$j"
		if [[ -r "$file" ]]; then
			value=$(jq -r '.InstalledFromUrl' "$file")
			if [[ "$value" == "null" ]]; then
				continue
			fi
			if [[ "$value" == "$NEW_URL" ]]; then
				continue
			fi
			if [[ "$value" == "OFFICIAL" ]]; then
				continue
			fi
			if [[ "$value" == "https://raw.githubusercontent.com/Ottermandias/SeaOfStars/main/repo.json" ]]; then
				continue
			fi
			# Use echo to pass the multiline string to while loop
			echo -e "$repolist" | while IFS=$'\n' read -r line; do
				# Check if the current line contains the search variable
				if [[ $value == *$line* ]]; then
					# Replace the URL using sed
					echo "Replacing repository for plugin '$foldername' ($file)"
					sed -i "s|\"InstalledFromUrl\": \".*\"|\"InstalledFromUrl\": \"$NEW_URL\"|" "$file"
				fi
			done
		else
			echo "$file is not readable"
		fi
	done
done
popd || return
