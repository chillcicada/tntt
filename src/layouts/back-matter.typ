/// Back Matter Layout
///
/// - twoside (bool): Whether to use two-sided layout.
/// - heading-numbering (dictorary): The numbering format for headings.
/// - figure-outlined (bool): Whether to outline figure numbers in figures index page.
/// - equation-numbering (str): The numbering format for equations.
/// - reset-counter (bool): Whether to reset the pages counter.
/// - it (content): The content of the back matter.
/// -> content
#let back-matter(
  // from entry
  twoside: false,
  // options
  heading-numbering: (formats: ("附录A", "A.1"), depth: 4, supplyment: " "),
  figure-outlined: false,
  equation-numbering: "(A.1)",
  reset-counter: false,
  // self
  it,
) = {
  import "../utils/numbering.typ": multi-numbering

  import "../imports.typ": ratchet

  // Page break
  pagebreak(weak: true, to: if twoside { "odd" })

  set figure(outlined: figure-outlined)

  show: ratchet.with(
    eq-outline: equation-numbering,
    fig-outline: heading-numbering.formats.last(),
  )

  // Reset the counter and numbering of headings
  counter(heading).update(0)

  set heading(numbering: multi-numbering.with(..heading-numbering), outlined: false)

  let __back-matter-has-page-counter-reset = state("__back-matter-has-page-counter-reset", false)

  show heading.where(level: 1): it => {
    // Only level 1 headings of the appendices are shown in the outline
    set heading(outlined: true)

    it

    if reset-counter and not __back-matter-has-page-counter-reset.get() {
      counter(page).update(1)
      __back-matter-has-page-counter-reset.update(true)
    }
  }

  it
}
