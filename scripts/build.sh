#!/usr/bin/env bash
# Preserve the anonymous/twoside smoke coverage for both document languages.
set -euo pipefail
destination=${1:-build/nightly}
mkdir -p "$destination"
for degree in bachelor master doctor postdoc; do
  for lang in zh en; do
    for anonymous in false true; do
      for twoside in false true; do
        name="$degree-academic-$lang"
        [[ "$anonymous" == true ]] && name+="-anonymous"
        [[ "$twoside" == true ]] && name+="-twoside"
        typst compile --root . --font-path fonts \
          --input "degree=$degree" --input "lang=$lang" \
          --input "anonymous=$anonymous" --input "twoside=$twoside" \
          template/main.typ "$destination/$name.pdf"
      done
    done
  done
done
