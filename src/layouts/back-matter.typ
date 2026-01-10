/// Back Matter Layout
///
/// - twoside (bool): Whether to use two-sided layout.
/// - heading-numbering (str): The numbering format for headings.
/// - figure-numbering (str): The numbering format for figures.
/// - figure-outlined (bool): Whether to outline figure numbers in figures index page.
/// - equation-numbering (str): The numbering format for equations.
/// - reset-counter (bool): Whether to reset the heading counter.
/// - it (content): The content to be displayed in the back matter.
/// -> content
#let back-matter(
  // from entry
  twoside: false,
  // options
  heading-numbering: (first-level: "附录A", depth: 4, format: "A.1 "),
  figure-numbering: "A.1",
  figure-outlined: false,
  equation-numbering: "A.1",
  reset-counter: true,
  // self
  it,
) = {
  import "../utils/numbering.typ": custom-numbering

  import "../imports.typ": ratchet

  // Page break
  pagebreak(weak: true, to: if twoside { "odd" })

  // Reset the counter and numbering
  if reset-counter { counter(heading).update(0) }

  set heading(
    numbering: custom-numbering.with(
      first-level: heading-numbering.first-level,
      depth: heading-numbering.depth,
      heading-numbering.format,
    ),
    bookmarked: true,
    outlined: false,
  )

  show heading.where(level: 1): set heading(outlined: true)

  set figure(outlined: figure-outlined)

  show: ratchet.with(
    eq-outline: equation-numbering,
    fig-outline: figure-numbering,
  )

  it
}
