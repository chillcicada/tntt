#let bilingual-bibliography(
  sources,
  title: auto,
  full: true,
  style: "gb-7714-2015-numeric",
) = {
  if not style.starts-with("gb-7714") {
    bibliography(bytes(sources), title: title, full: full, style: style)
    return
  }

  import "../imports.typ": gb7714-bilingual
  import gb7714-bilingual: gb7714-bibliography, init-gb7714

  let gb7714-version = style.trim("gb-7714-", at: start).slice(0, 4)
  let gb7714-style = style.trim("gb-7714-" + gb7714-version + "-", at: start)

  show: init-gb7714.with(sources, version: gb7714-version, style: gb7714-style)
  gb7714-bibliography(title: title)
}
