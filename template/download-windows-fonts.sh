#!/usr/bin/env bash

set -euo pipefail

font_dir=${1:?usage: download-windows-fonts.sh FONT_DIR [SEARCH] [ARCH]}
uup_search=${2:-Windows 11 24H2 amd64}
uup_arch=${3:-amd64}
uup_api=${UUP_API:-https://api.uupdump.net}

required_commands=(curl jq 7z install find mktemp)
font_files=(
	arial.ttf arialbd.ttf ariali.ttf arialbi.ttf
	times.ttf timesbd.ttf timesi.ttf timesbi.ttf
	cour.ttf courbd.ttf couri.ttf courbi.ttf
	simsun.ttc simhei.ttf simkai.ttf simfang.ttf
)

for command_name in "${required_commands[@]}"; do
	if ! command -v "$command_name" >/dev/null; then
		printf 'error: required command not found: %s\n' "$command_name" >&2
		exit 1
	fi
done

printf '%s\n' \
	'WARNING: This target downloads proprietary Microsoft Windows font files.' \
	'You may proceed only if you understand the applicable Microsoft license terms' \
	'and hold a valid Windows license permitting this use.' \
	'The downloaded fonts are for local use only and must not be redistributed.'
read -r -p 'Do you understand and confirm that you hold such a license? [y/N] ' reply
case "$reply" in
	y | Y) ;;
	*)
		printf '%s\n' 'Windows font download cancelled.'
		exit 2
		;;
esac

stage=$(mktemp -d "${TMPDIR:-/tmp}/tntt-windows-fonts.XXXXXX")
cleanup() {
	find "$stage" -depth -delete
}
trap cleanup EXIT

list_json=$stage/list.json
files_json=$stage/files.json

printf 'Discovering a Windows build matching %q...\n' "$uup_search"
curl --proto '=https' --tlsv1.2 --compressed -fsSL --retry 3 \
	--retry-all-errors --max-time 120 --get \
	--data-urlencode "search=$uup_search" \
	--data-urlencode 'sortByDate=1' \
	"$uup_api/listid.php" -o "$list_json"

build_id=$(jq -er --arg arch "$uup_arch" '
  .response.builds
  | to_entries
  | map(.value)
  | map(select(.arch == $arch and .uuid != null))
  | sort_by(.created)
  | last
  | .uuid
' "$list_json")
build_title=$(jq -er --arg id "$build_id" '
  .response.builds
  | to_entries
  | map(.value)
  | map(select(.uuid == $id))
  | first
  | .title
' "$list_json")
printf 'Using %s (%s).\n' "$build_title" "$build_id"

curl --proto '=https' --tlsv1.2 --compressed -fsSL --retry 3 \
	--retry-all-errors --max-time 300 \
	"$uup_api/get.php?id=$build_id" -o "$files_json"

component_metadata() {
	local component_name=$1
	jq -er --arg name "$component_name" '
    .response.files
    | to_entries
    | map(select((.key | ascii_downcase) == ($name | ascii_downcase)))
    | (first // error("component not found: " + $name))
    | [.key, .value.url, .value.size]
    | @tsv
  ' "$files_json"
}

download_component() {
	local component_name=$1
	local destination=$2
	local metadata resolved_name url size

	metadata=$(component_metadata "$component_name")
	IFS=$'\t' read -r resolved_name url size <<<"$metadata"

	case "$url" in
		http://*.dl.delivery.mp.microsoft.com/* | https://*.dl.delivery.mp.microsoft.com/* | \
			http://*.download.windowsupdate.com/* | https://*.download.windowsupdate.com/*) ;;
		*)
			printf 'error: refusing non-Microsoft component URL: %s\n' "$url" >&2
			exit 1
			;;
	esac

	printf 'Downloading %s (%d MiB)...\n' "$resolved_name" "$((size / 1024 / 1024))"
	curl --proto '=http,https' --tlsv1.2 -fL --retry 3 --retry-all-errors \
		--continue-at - "$url" -o "$destination"
}

hans_cab=$stage/fonts-hans.cab
desktop_esd=$stage/client-desktop-required.esd
download_component \
	"Microsoft-Windows-LanguageFeatures-Fonts-Hans-Package-$uup_arch.cab" \
	"$hans_cab"
download_component \
	'Microsoft-Windows-Client-Desktop-Required-Package.ESD' \
	"$desktop_esd"

printf '%s\n' 'Checking downloaded component archives...'
7z t "$hans_cab" >/dev/null
7z t "$desktop_esd" >/dev/null

extracted=$stage/extracted
mkdir -p "$extracted/hans" "$extracted/base"
7z x -y -o"$extracted/hans" "$hans_cab" >/dev/null
7z e -y -o"$extracted/base" "$desktop_esd" \
	'-ir!*/arial*.ttf' \
	'-ir!*/cour*.ttf' \
	'-ir!*/times*.ttf' \
	'-ir!*/simsun.ttc' >/dev/null

declare -A font_sources=()
for font_name in "${font_files[@]}"; do
	source_path=$(find "$extracted" -type f -iname "$font_name" -print -quit)
	if [[ -z "$source_path" ]]; then
		printf 'error: required font not found after extraction: %s\n' "$font_name" >&2
		exit 1
	fi
	font_sources[$font_name]=$source_path
done

mkdir -p "$font_dir"
for font_name in "${font_files[@]}"; do
	install -m 644 "${font_sources[$font_name]}" "$font_dir/$font_name"
done

printf 'Installed %d Windows font files in %s.\n' "${#font_files[@]}" "$font_dir"
