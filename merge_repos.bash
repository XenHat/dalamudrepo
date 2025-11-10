#!/bin/env bash
index=0

while IFS= read -r line; do
	wget -qO- "$line" >"repo.${index}.tmp.json"
	((index++))
done <repolist
jq -s 'add' ./*.tmp.json >new_repo.json
rm ./*.tmp.json
