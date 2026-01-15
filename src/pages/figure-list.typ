/// Figure Index Page
///
/// - twoside (bool): Whether to use two-sided printing.
/// - title (content): The title of the figure index page.
/// - outlined (bool): Whether to outline the page.
/// - bookmarked (bool): Whether to add a bookmark for the page.
/// -> content
#let figure-list(
  // from entry
  twoside: false,
  // options
  title: [插图清单],
  outlined: false,
  bookmarked: true,
) = {
  pagebreak(weak: true, to: if twoside { "odd" })

  heading(level: 1, numbering: none, outlined: outlined, bookmarked: bookmarked, title)

  outline(target: figure.where(kind: image), title: none)
}
