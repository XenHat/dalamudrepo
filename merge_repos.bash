#!/bin/env bash
index=0

while IFS= read -r line; do
	wget -qO- "$line" >"repo.${index}.tmp.json"
	wget -O "repo.${index}.tmp.json" "$line"
	((index++))
done <repolist
jq -s 'add' ./*.tmp.json >new_repo.json
jq -s 'add' ./repo.*.tmp.json >new_repo.json
rm ./repo.*.tmp.json
