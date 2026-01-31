/// Figure and Table Index Page
///
/// - twoside (bool | str): Whether to use two-sided printing.
/// - title (content): The title of the master list page.
/// - outlined (bool): Whether to outline the page.
/// - bookmarked (bool): Whether to add a bookmark for the page.
/// - body (content): The body content of the page.
/// -> content
#let figure-table-list(
  // from entry
  twoside: false,
  // options
  title: [插图和附表清单],
  outlined: false,
  bookmarked: true,
  body: {
    outline(target: figure.where(kind: image), title: none)
    par[] // add a blank line
    outline(target: figure.where(kind: table), title: none)
  },
) = {
  import "../utils/page.typ": use-twoside

  use-twoside(twoside)

  heading(level: 1, numbering: none, outlined: outlined, bookmarked: bookmarked, title)

  body
}

/// Master List Page
#let master-list(target: figure, ..args) = figure-table-list(
  title: [总清单],
  body: outline(target: target, title: none),
  ..args,
)

/// Figure Index Page
#let figure-list(..args) = master-list(title: [插图清单], target: figure.where(kind: image), ..args)

/// Table Index Page
#let table-list(..args) = master-list(title: [附表清单], target: figure.where(kind: table), ..args)

/// Equation Index Page
#let equation-list(..args) = master-list(title: [公式清单], target: math.equation.where(block: true), ..args)
