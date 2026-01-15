/// Table Index Page
///
/// - twoside (bool): Whether to use two-sided printing
/// - title (content): The title of the table index page
/// - outlined (bool): Whether to outline the page
/// - bookmarked (bool): Whether to add a bookmark for the page
/// -> content
#let table-list(
  // from entry
  twoside: false,
  // options
  title: [附表清单],
  outlined: false,
  bookmarked: true,
) = {
  pagebreak(weak: true, to: if twoside { "odd" })

  heading(level: 1, numbering: none, outlined: outlined, bookmarked: bookmarked, title)

  outline(target: figure.where(kind: table), title: none)
}
