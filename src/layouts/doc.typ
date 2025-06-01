#import "../utils/font.typ": use-size

#import "../imports.typ": cuti
#import cuti: show-cn-fakebold

#let meta(
  // from entry
  info: (:),
  // options
  lang: "zh",
  region: "cn",
  margin: 3cm,
  fallback: false,
  // self
  it,
) = {
  if type(info.title) == str { info.title = info.title.split("\n") }

  show: show-cn-fakebold

  set text(fallback: fallback, lang: lang, region: region)

  set page(margin: margin, paper: "a4")

  set document(
    title: (("",) + info.title).sum(),
    author: info.author,
  )

  set heading(bookmarked: true)

  it
}

#let doc(
  // from entry
  fonts: (:),
  // options
  indent: 2em,
  justify: true,
  leading: 1em,
  spacing: 1em,
  code-block-leading: 1em,
  code-block-spacing: 1em,
  heading-size: "三号",
  front-vspace: 27.5pt,
  title-vspace: 21.2pt,
  body-size: "小四",
  fontnote-size: "五号",
  math-size: "小四",
  underline-offset: .1em,
  underline-stroke: .05em,
  underline-evade: true,
  // self
  it,
) = {
  /// Paragraph
  set par(
    justify: justify,
    leading: leading,
    spacing: spacing,
    first-line-indent: (amount: indent, all: true),
  )

  /// List
  set list(indent: indent)

  /// Raw
  show raw: set text(font: fonts.Mono)

  // unset paragraph for raw block
  show raw.where(block: true): set par(
    leading: code-block-leading,
    spacing: code-block-spacing,
  )

  /// Term
  show terms: set par(first-line-indent: 0em)

  /// Fontnote
  show footnote.entry: set text(
    font: fonts.SongTi,
    size: use-size("五号"),
  )

  /// Math Equation
  show math.equation: set text(font: fonts.Math, size: use-size(math-size))

  /// Heading
  show heading: set text(font: fonts.HeiTi, size: use-size(heading-size))

  show heading.where(level: 1): it => {
    set text(weight: "regular")

    v(front-vspace)

    align(center, it)

    v(title-vspace)
  }

  /// Body Text
  set text(font: fonts.SongTi, size: use-size(body-size))

  /// Underline
  set underline(
    offset: underline-offset,
    stroke: underline-stroke,
    evade: underline-evade,
  )

  /// Stroke

  it
}
