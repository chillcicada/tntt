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
) = {
  pagebreak(weak: true, to: if twoside { "odd" })

  outline(title: title, target: figure.where(kind: image))
}
