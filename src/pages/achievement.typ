/// Achievement Page
///
/// - anonymous (bool): Whether to use anonymous mode.
/// - twoside (bool): Whether to use two-sided layout.
/// - doctype (string): The document type.
/// - title (content): The title of the achievement page.
/// - outlined (bool): Whether to outline the page.
/// - bookmarked (bool): Whether to add a bookmark for the page.
/// - it (content): The content of the achievement page.
/// -> content
#let achievement(
  // from entry
  anonymous: false,
  twoside: false,
  doctype: "bachelor",
  // options
  title: [在学期间参加课题的研究成果],
  outlined: true,
  bookmarked: true,
  // self
  it,
) = {
  if anonymous { return }

  pagebreak(weak: true, to: if twoside { "odd" })

  // TODO: the default title is affected by doctype
  heading(level: 1, numbering: none, outlined: outlined, bookmarked: bookmarked, title)

  it
}
