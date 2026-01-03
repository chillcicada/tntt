/// Figure Index Page
///
/// - twoside (bool): Whether to use two-sided printing
/// - title (content): The title of the figure index page
/// - outlined (bool): Whether to outline the page
/// -> content
#let figure-list(
  // from entry
  twoside: false,
  // options
  title: [插图清单],
  outlined: false,
  bookmarked: true,
) = {
  import "../imports.typ": i-figured

  pagebreak(weak: true, to: if twoside { "odd" })

  heading(level: 1, numbering: none, outlined: outlined, bookmarked: bookmarked, title)

  i-figured.outline(target-kind: image, title: none)
}
