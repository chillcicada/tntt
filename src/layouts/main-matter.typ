/// Main Matter Layout
///
/// - twoside (bool): Whether to use two-sided layout.
/// - page-numbering (str): The numbering format for the page.
/// - heading-numbering (str): The numbering format for headings.
/// - reset-footnote (bool): Whether to reset the footnote counter by page.
/// - it (content): The content to be displayed in the main matter.
/// -> content
#let main-matter(
  // from entry
  twoside: false,
  // options
  page-numbering: "1",
  heading-numbering: (first-level: "第1章", depth: 4, format: "1.1"),
  equation-numbering: "1-1",
  reset-footnote: true,
  // self
  it,
) = {
  import "../utils/font.typ": use-size
  import "../utils/util.typ": array-at
  import "../utils/numbering.typ": custom-numbering

  import "../imports.typ": ratchet

  show: ratchet.with(
    eq-outline: equation-numbering,
    fig-outline: heading-numbering.format,
    reset-figure-kinds: (table, image, raw, "algorithm"),
  )

  // Page break
  pagebreak(weak: true, to: if twoside { "odd" })

  set heading(
    numbering: custom-numbering.with(
      first-level: heading-numbering.first-level,
      depth: heading-numbering.depth,
      heading-numbering.format,
    ),
    bookmarked: true,
  )

  set page(numbering: page-numbering, header: { if reset-footnote { counter(footnote).update(0) } })

  counter(page).update(1)

  it
}
