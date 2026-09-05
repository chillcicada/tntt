# list all available recipes
[private]
default:
  @just --list --unsorted

# update thumbnail
thumbnail: fonts
  @typst c -f png --pages 3 --root . --font-path fonts --input lang=zh template/main.typ thumbnail.png

# build pdf
build lang="zh": fonts
  @typst c --root . --font-path fonts --input lang={{lang}} template/main.typ

# export profile
profile: fonts
  @typst c --root . --font-path fonts template/main.typ --timings record.json

# download checksum-pinned open fonts
fonts:
  @bash scripts/fonts.sh fonts

# compile the degree/language/anonymous/twoside matrix
smoke: fonts
  @bash scripts/build.sh
