repos=(
	'https://git.anna.lgbt/ascclemens/plugin_repo/raw/branch/main/unofficial.json'
	'https://raw.githubusercontent.com/Ottermandias/Glamourer/main/repo.json'
	'https://raw.githubusercontent.com/xivdev/Penumbra/master/repo.json'
	'https://raw.githubusercontent.com/Penumbra-Sync/repo/main/plogonmaster.json'
	'https://raw.githubusercontent.com/XIV-Tools/DalamudPlugins/main/repo.json'
	'https://raw.githubusercontent.com/SF-XIV/dalamud-plugins/main/repo.json'
	'https://raw.githubusercontent.com/ktisis-tools/Ktisis/main/repo.json'
	'https://repo.heliosphere.app/'
	'https://raw.githubusercontent.com/chirpxiv/PalettePlus/main/repo.json'
	'https://raw.githubusercontent.com/LeonBlade/DalamudPlugins/main/repo.json'
	'https://raw.githubusercontent.com/Aida-Enna/XIVPlugins/main/repo.json'
)
names=(
	'anna'
	'glamourer'
	'penumbra'
	'maresync'
	'xivtools'
	'sfxiv'
	'ktsis'
	'heliosphere'
	'paletteplus'
	'leonblade'
	'aidaenna'
)

#rm sources/*.json -f
idx=0
for repo in "${repos[@]}"; do
	echo "$repo"
	curl -o "sources/${names[$idx]}.json" -z "sources/${names[$idx]}.json" "$repo"
	((idx++))
done
rm repo.json
rm tmp*.json
for file in sources/*.json; do
	echo "====================$file========================="
	jq '.[]' $file >>tmp.json
done
# re-encapsulate the data into an actual array
jq -s >tmp2.json <tmp.json
# Remove some plugins from the manifest (i.e. merged into main, which causes warnings in log)
jq 'del(.[] | select(.Name == "Fullscreen Toggle"))' < tmp2.json > repo.json
#rm tmp*.json
