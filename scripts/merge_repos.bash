#!/bin/env bash
index=0

while IFS= read -r line; do
	# Get the data inside and save it pre-formatted consistently
	echo "Downloading $line"
	if ! wget -q -O - "$line" | jq '.' >repo.${index}.tmp.json 2>/dev/null; then
		echo "  Skipping invalid JSON from $line"
		rm -f repo.${index}.tmp.json
		continue
	fi
	((index++))
done <assets/repolist
echo "Merging all repos"
jq -n 'reduce inputs as $in (null;
. + if $in|type == "array" then $in else [$in] end)
' ./repo.*.tmp.json >repo.reduced.tmp.json
jq 'sort_by(.Name)' --sort-keys ./repo.reduced.tmp.json >repo.json
rm repo.*.tmp.json
