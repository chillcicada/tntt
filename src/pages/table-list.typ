#import "../imports.typ": i-figured

/// Table Index Page
#let table-list(
  // from entry
  twoside: false,
  // options
  title: [表格索引],
  outlined: true,
) = {
  pagebreak(weak: true, to: if twoside { "odd" })

  heading(
    level: 1,
    numbering: none,
    outlined: outlined,
    title,
  )

  i-figured.outline(target-kind: table, title: none)
}
