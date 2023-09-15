{
	wget -qO- 'https://raw.githubusercontent.com/SF-XIV/dalamud-plugins/main/repo.json'
	wget -qO- 'https://raw.githubusercontent.com/LeonBlade/DalamudPlugins/main/repo.json'
	wget -qO- 'https://raw.githubusercontent.com/Aida-Enna/XIVPlugins/main/repo.json'
} >tmp.json
jq <tmp.json '.[]' | jq -s | jq 'del(.[] | select(.Name == "Fullscreen Toggle"))' > new_repo.json
diff repo.json new_repo.json
mv new_repo.json repo.json
rm tmp*.json
