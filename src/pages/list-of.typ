/// Master List Page
///
/// - twoside (bool): Whether to use two-sided printing.
/// - title (content): The title of the master list page.
/// - outlined (bool): Whether to outline the page.
/// - bookmarked (bool): Whether to add a bookmark for the page.
/// - target (selector): The target figures to be listed.
/// -> content
#let master-list(
  // from entry
  twoside: false,
  // options
  title: [总清单],
  outlined: false,
  bookmarked: true,
  target: figure,
) = {
  pagebreak(weak: true, to: if twoside { "odd" })

  heading(level: 1, numbering: none, outlined: outlined, bookmarked: bookmarked, title)

  outline(target: target, title: none)
}

/// Figure and Table Index Page
#let figure-table-list(
  twoside: false,
  title: [插图和附表清单],
  outlined: false,
  bookmarked: true,
) = {
  pagebreak(weak: true, to: if twoside { "odd" })

  heading(level: 1, numbering: none, outlined: outlined, bookmarked: bookmarked, title)

  outline(target: figure.where(kind: image), title: none)

  "" // add a blank line

  outline(target: figure.where(kind: table), title: none)
}

/// Figure Index Page
#let figure-list(..args) = master-list(
  title: [插图清单],
  target: figure.where(kind: image),
  ..args,
)

/// Table Index Page
#let table-list(..args) = master-list(
  title: [附表清单],
  target: figure.where(kind: table),
  ..args,
)

/// Equation Index Page
#let equation-list(..args) = master-list(
  title: [公式清单],
  target: math.equation.where(block: true),
  ..args,
)
