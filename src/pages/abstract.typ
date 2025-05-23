#import "../utils/font.typ": use-size

#let abstract(
  // from entry
  anonymous: false,
  twoside: false,
  // options
  outlined: false,
  title: [中文摘要],
  title-vspace: 1.28em,
  body-vspace: 1em,
  back: [*关键词：*],
  keywords: (),
  keyword-sperator: "；",
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
