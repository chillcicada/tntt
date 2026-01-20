/// Main Matter Layout
///
/// - twoside (bool | str): Whether to use two-sided layout.
/// - page-numbering (str): The numbering format for the page.
/// - heading-numbering (dictorary): The numbering format for headings.
/// - figure-numbering (str | auto): The numbering format for figures.
/// - equation-numbering (str | auto): The numbering format for equations.
/// - it (content): The content to be displayed in the main matter.
/// -> content
#let main-matter(
  // from entry
  twoside: false,
  // options
  page-numbering: "1",
  heading-numbering: (formats: ("第1章", "1.1"), depth: 4, supplyment: " "),
  figure-numbering: auto,
  equation-numbering: auto,
  // self
  it,
) = {
  import "../utils/font.typ": use-size
  import "../utils/page.typ": use-twoside
  import "../utils/util.typ": array-at
  import "../utils/numbering.typ": multi-numbering

  import "../imports.typ": ratchet

  if figure-numbering == auto { figure-numbering = heading-numbering.formats.last() }
  if equation-numbering == auto { equation-numbering = "(" + heading-numbering.formats.last() + ")" }

  // Page break
  use-twoside(twoside)

  show: ratchet.with(
    eq-outline: equation-numbering,
    fig-outline: figure-numbering,
    reset-figure-kinds: (table, image, raw, "algorithm"),
  )

  set heading(numbering: multi-numbering.with(..heading-numbering))

  // Reset the counter of pages
  counter(page).update(1)
  set page(numbering: page-numbering)

  it
}
