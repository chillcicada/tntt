/// Back Matter Layout
///
/// - twoside (bool): Whether to use two-sided layout.
/// - heading-numbering (array): The numbering format for headings.
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
  heading-numbering: (formats: ("附录A", "A.1 "), depth: 4), // added space after A.1 for better appearance
  figure-numbering: "A.1",
  figure-outlined: false,
  equation-numbering: "(A.1)",
  reset-counter: true,
  // self
  it,
) = {
  import "../utils/numbering.typ": multi-numbering

  import "../imports.typ": ratchet

  // Page break
  pagebreak(weak: true, to: if twoside { "odd" })

  // Reset the counter and numbering
  if reset-counter { counter(heading).update(0) }

  // Only level 1 headings of the appendices are shown in the outline
  set heading(numbering: multi-numbering.with(heading-numbering.formats, heading-numbering.depth), outlined: false)
  show heading.where(level: 1): set heading(outlined: true)

  set figure(outlined: figure-outlined)

  show: ratchet.with(
    eq-outline: equation-numbering,
    fig-outline: figure-numbering,
  )

  it
}
