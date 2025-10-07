# list all available recipes
default:
  @just --list

# update thumbnail
thumbnail:
  @typst c -f png --pages 3 --root . template/thesis.typ thumbnail.png
