#import "../utils/numbering.typ": custom-numbering

#import "../imports.typ": i-figured

#let back-matter(
  // from entry
  fonts: (:),
  // options
  heading-numbering: (first-level: "附录A ", depth: 4, format: "A.1 "),
  figure-numbering: "A.1",
  equation-numbering: "(A.1)",
  reset-counter: true,
  // self
  it,
) = {
  if reset-counter { counter(heading).update(0) }

  set heading(
    numbering: custom-numbering.with(
      first-level: heading-numbering.first-level,
      depth: heading-numbering.depth,
      heading-numbering.format,
    ),
  )

  show figure: i-figured.show-figure.with(numbering: figure-numbering)

  show math.equation.where(block: true): i-figured.show-equation.with(numbering: equation-numbering)

  it
}
