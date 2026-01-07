/// Advisor Comment Page
///
/// - anonymous (bool): Whether to use anonymous mode.
/// - twoside (bool): Whether to use two-sided layout.
/// - doctype ("master"): The document type.
/// - title (content): The title of the acknowledgement page.
/// - outlined (bool): Whether to outline the page.
/// - bookmarked (bool): Whether to add a bookmark for the page.
/// - it (content): The content of the acknowledgement page.
/// -> content
#let advisor-comment(
  // from entry
  anonymous: false,
  twoside: false,
  doctype: "master",
  // options
  title: [指导教师评语],
  outlined: true,
  bookmarked: true,
  // self
  it,
) = {
  if anonymous { return }

  if doctype not in ("master", "doctor", "postdoc") { return }

  pagebreak(weak: true, to: if twoside { "odd" })

  heading(level: 1, numbering: none, outlined: outlined, bookmarked: bookmarked, title)

  it
}
