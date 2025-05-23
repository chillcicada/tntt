#import "../utils/font.typ": use-size, _support-font-family

#let outline-wrapper(
  // from entry
  twoside: false,
  fonts: (:),
  // options
  depth: 4,
  font: ("HeiTi", "SongTi"),
  size: ("四号", "小四"),
  outlined: false,
  title: [目　　录],
  title-vspace: 1.28em,
  above: (25pt, 14pt),
  below: (14pt, 14pt),
  indent: (0pt, 28pt, 22pt),
  gap: .3em,
  fill: (repeat([.], gap: 0.15em),),
) = {
  /// Parse the outline configuration
  for it in font {
    assert(
      _support-font-family.contains(it),
      message: "Font family " + it + " is not supported.",
    )
  }
  font = font.map(name => fonts.at(name))

  size = size.map(name => use-size(name))

  /// Render the outline
  pagebreak(weak: true, to: if twoside { "odd" })

  heading(
    level: 1,
    outlined: outlined,
    title,
  )

  v(title-vspace)

  // set outline style
  set outline(indent: level => indent.slice(0, calc.min(level + 1, indent.len())).sum())

  show outline.entry: entry => block(
    above: above.at(entry.level - 1, default: above.last()),
    below: below.at(entry.level - 1, default: below.last()),
    link(
      entry.element.location(),
      entry.indented(
        none,
        {
          text(
            font: font.at(entry.level - 1, default: font.last()),
            size: size.at(entry.level - 1, default: size.last()),
            {
              if entry.prefix() not in (none, []) {
                entry.prefix()
                h(gap)
              }
              entry.body()
            },
          )
          box(width: 1fr, inset: (x: .25em), fill.at(entry.level - 1, default: fill.last()))
          entry.page()
        },
        gap: 0pt,
      ),
    ),
  )

  // display the outline
  outline(title: none, depth: depth)
}
