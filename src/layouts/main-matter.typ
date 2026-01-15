/// Main Matter Layout
///
/// - twoside (bool): Whether to use two-sided layout.
/// - page-numbering (str): The numbering format for the page.
/// - heading-numbering (array): The numbering format for headings.
/// - it (content): The content to be displayed in the main matter.
/// -> content
#let main-matter(
  // from entry
  twoside: false,
  // options
  page-numbering: "1",
  heading-numbering: (formats: ("第1章", "1.1"), depth: 4),
  equation-numbering: "(1-1)",
  // self
  it,
) = {
  import "../utils/font.typ": use-size
  import "../utils/util.typ": array-at
  import "../utils/numbering.typ": multi-numbering

  import "../imports.typ": ratchet

  show: ratchet.with(
    eq-outline: equation-numbering,
    fig-outline: heading-numbering.format,
    reset-figure-kinds: (table, image, raw, "algorithm"),
  )

  // Page break
  pagebreak(weak: true, to: if twoside { "odd" })

  set heading(numbering: multi-numbering.with(heading-numbering.formats, heading-numbering.depth))

  set page(numbering: page-numbering)

  counter(page).update(1)

  it
}
