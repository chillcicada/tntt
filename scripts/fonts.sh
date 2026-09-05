#!/usr/bin/env bash
# Install the same open fonts for local builds, CI, and release previews.
set -euo pipefail
script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
destination=${1:-fonts}
mkdir -p "$destination"
lock_hash=$(sha256sum "$script_dir/fonts.sha256" | cut -d ' ' -f 1)
if [[ -f "$destination/.fonts-$lock_hash" ]]; then
  exit 0
fi
archive_dir=$(mktemp -d)
trap 'rm -f "$archive_dir/fandol.zip" "$archive_dir/xits.zip" "$archive_dir/tex-gyre.zip"; rmdir "$archive_dir"' EXIT
while read -r digest archive; do
  [[ -z "$digest" || "$digest" == \#* ]] && continue
  curl --proto '=https' --tlsv1.2 -fLsS --retry 3 \
    "https://mirrors.ctan.org/fonts/$archive" -o "$archive_dir/$archive"
  (cd "$archive_dir" && printf '%s  %s\n' "$digest" "$archive" | sha256sum --check -)
  unzip -qo "$archive_dir/$archive" -d "$destination"
done < "$script_dir/fonts.sha256"
touch "$destination/.fonts-$lock_hash"
