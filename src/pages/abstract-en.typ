#import "../utils/font.typ": use-size

#let abstract-en(
  // from entry
  anonymous: false,
  twoside: false,
  // options
  outlined: false,
  title: [ABSTRACT],
  title-vspace: 1.28em,
  body-vspace: 1em,
  back: [*Keywords: *],
  keywords: (),
  keyword-sperator: "; ",
  // self
  it,
) = {
  pagebreak(weak: true, to: if twoside { "odd" })

  heading(
    level: 1,
    outlined: outlined,
    title,
  )

  v(title-vspace)

  it

  v(body-vspace)

  back
  (("",) + keywords.intersperse(keyword-sperator)).sum()
}
