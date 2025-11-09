# list all available recipes
[private]
default:
  @just --list --unsorted

# update thumbnail
thumbnail:
  @typst c -f png --pages 3 --root . template/thesis.typ thumbnail.png

# build pdf
build:
  @typst c --root . template/thesis.typ

# export profile
profile:
  @typst c --root . template/thesis.typ --timings record.json
