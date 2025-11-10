#!/bin/env bash
index=0

while IFS= read -r line; do
	wget -qO- "$line" >"repo.${index}.tmp.json"
	wget -O "repo.${index}.tmp.json" "$line"
	((index++))
done <repolist
for f in ./repo.*.tmp.json; do
	if [[ $(du "$f" | cut -f1) -gt 0 ]]; then
		jq -s 'add' "$f" >"new_repo.json"
	else
		echo "ERR: Skipped $f because it is empty."
	fi
	rm "$f"
done
