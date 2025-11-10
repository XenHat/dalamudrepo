#!/bin/env bash
index=0

while IFS= read -r line; do
	# Get the data inside and save it pre-formatted consistently
	echo "Downloading $line"
	wget -q -O - "$line" | jq '.' >repo.${index}.tmp.json
	((index++))
done <repolist
echo "Merging all repos"
jq -n 'reduce inputs as $in (null;
. + if $in|type == "array" then $in else [$in] end)
' ./repo.*.tmp.json >repo.json
rm repo.*.tmp.json
