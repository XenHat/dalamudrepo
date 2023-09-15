echo "Checking for JQ"
command -v jq
echo "Downloading repos"
{
	wget -qO- 'https://raw.githubusercontent.com/SF-XIV/dalamud-plugins/main/repo.json'
	wget -qO- 'https://raw.githubusercontent.com/LeonBlade/DalamudPlugins/main/repo.json'
	wget -qO- 'https://raw.githubusercontent.com/Aida-Enna/XIVPlugins/main/repo.json'
} >tmp.json
echo "re-formatting new JSON file"
jq <tmp.json '.[]' | jq -s | jq 'del(.[] | select(.Name == "Fullscreen Toggle"))' > new_repo.json
echo "Checking for differences"
diff repo.json new_repo.json
echo "overwriting repo JSON with new file"
mv -v new_repo.json repo.json
rm -v tmp*.json
