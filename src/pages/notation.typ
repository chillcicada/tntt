/// Notation Page
#let notation(
  // from entry
  twoside: false,
  // options
  outlined: false,
  title: [符号对照表],
  title-vspace: 1.28em,
  width: 350pt,
  columns: (60pt, 1fr),
  row-gutter: 16pt,
  ..args,
  // self
  it,
) = {
  pagebreak(weak: true, to: if twoside { "odd" })

  heading(
    level: 1,
    numbering: none,
    outlined: outlined,
    title,
  )

  v(title-vspace)

  align(
    center,
    block(
      width: width,
      align(
        start,
        grid(
          columns: columns,
          row-gutter: row-gutter,
          ..args,
          ..it.children.filter(it => it.func() == terms.item).map(it => (it.term, it.description)).flatten()
        ),
      ),
    ),
  )

  if twoside { pagebreak() + " " }
}
