#import "../utils/font.typ": font-size

/// Front matter layout
#let front-matter(
  // from entry
  fonts: (:),
  // options
  page-start: 0,
  page-numbering: "I",
  // self
  it,
) = {
  // Reset the counter
  counter(page).update(page-start)
  set page(numbering: page-numbering)

  it
}
