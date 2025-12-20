/// Table Index Page
///
/// - twoside (bool): Whether to use two-sided printing
/// - title (content): The title of the table index page
/// - outlined (bool): Whether to outline the page
/// -> content
#let table-list(
  // from entry
  twoside: false,
  // options
  title: [附表清单],
  outlined: false,
) = {
  pagebreak(weak: true, to: if twoside { "odd" })

  // heading(level: 1, numbering: none, outlined: outlined, bookmarked: true, title)

  outline(title: title, target: figure.where(kind: table))
}
