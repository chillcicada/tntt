#import "../utils/font.typ": use-size
#import "../utils/numbering.typ": custom-numbering
#import "../utils/heading.typ": heading-display, active-heading, current-heading

#import "../imports.typ": i-figured

#let main-matter(
  // from entry
  twoside: false,
  fonts: (:),
  // options
  page-numbering: "1",
  heading-numbering: (first-level: "第1章", depth: 4, format: "1.1"),
  heading-weight: ("regular",),
  // heading-above: (2 * 15.6pt - 0.7em, 2 * 15.6pt - 0.7em),
  // heading-below: (2 * 15.6pt - 0.7em, 1.5 * 15.6pt - 0.7em),
  heading-pagebreak: (true, false),
  heading-align: (center, auto),
  caption-separator: "  ",
  caption-style: strong,
  caption-size: "五号",
  reset-footnote: true,
  ..args,
  // self
  it,
) = {
  set page(numbering: page-numbering)

  show heading: i-figured.reset-counters

  set heading(
    numbering: custom-numbering.with(
      first-level: heading-numbering.first-level,
      depth: heading-numbering.depth,
      heading-numbering.format,
    ),
  )

  show math.equation.where(block: true): i-figured.show-equation

  show figure: i-figured.show-figure
  show figure.where(kind: table): set figure.caption(position: top)
  set figure.caption(separator: caption-separator)
  show figure.caption: caption-style
  show figure.caption: set text(font: fonts.SongTi, size: use-size(caption-size))

  let unpairs(pairs) = {
    let dict = (:)
    for pair in pairs {
      dict.insert(..pair)
    }
    dict
  }

  let heading-text-args-lists = args
    .named()
    .pairs()
    .filter(pair => pair.at(0).starts-with("heading-"))
    .map(pair => (pair.at(0).slice("heading-".len()), pair.at(1)))

  let array-at(arr, pos) = {
    arr.at(calc.min(pos, arr.len()) - 1)
  }

  show heading: it => {
    set text(
      weight: array-at(heading-weight, it.level),
      ..unpairs(heading-text-args-lists.map(pair => (pair.at(0), array-at(pair.at(1), it.level)))),
    )
    set block(
      // above: array-at(heading-above, it.level),
      // below: array-at(heading-below, it.level),
    )
    it
  }

  show heading: it => {
    if array-at(heading-pagebreak, it.level) {
      if "label" not in it.fields() or str(it.label) != "no-auto-pagebreak" {
        pagebreak(weak: true)
      }
    }
    if array-at(heading-align, it.level) != auto {
      set align(array-at(heading-align, it.level))
      it
    } else {
      it
    }
  }

  set page(header: { if reset-footnote { counter(footnote).update(0) } })

  context {
    if calc.even(here().page()) {
      set page(numbering: "I", header: none)
      pagebreak() + " "
    }
  }

  counter(page).update(1)

  it
}
