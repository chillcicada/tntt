/// Bilingual bibliography
///
/// - sources (str | bytes): The bibliography sources, in BibTeX format or bytes
/// - title (content): The title of the bibliography page
/// - full (bool): Whether to show the unquoted bibliography entry
/// - full-control (none | function): The control function for the gb-7714 bibliography
/// - args (dictionary): Other options for gb-7714 bibliography
/// -> content
#let bilingual-bibliography(
  sources,
  title: auto,
  full: true,
  style: "gb-7714-2015-numeric",
  full-control: none,
  ..args,
) = {
  if not style.starts-with("gb-7714") {
    bibliography(bytes(sources), title: title, full: full, style: style)
    return
  }

  import "../imports.typ": gb7714-bilingual
  import gb7714-bilingual: gb7714-bibliography, init-gb7714

  let gb7714-version = style.trim("gb-7714-", at: start).slice(0, 4)
  let gb7714-style = style.trim("gb-7714-" + gb7714-version + "-", at: start)

  show: init-gb7714.with(sources, version: gb7714-version, style: gb7714-style, ..args)
  gb7714-bibliography(title: title, full: full, full-control: full-control)
}
