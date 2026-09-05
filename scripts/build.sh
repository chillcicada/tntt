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
          template/thesis.typ "$destination/$name.pdf"
      done
    done
  done
done

# Keep the long reference example healthy without distributing it to new users.
for lang in zh en; do
  typst compile --root . --font-path fonts --input "lang=$lang" \
    contrib/latex-parity/main.typ "$destination/reference-$lang.pdf"
done

typst compile --root . --font-path fonts contrib/writing-packages.typ \
  "$destination/writing-packages.pdf"
