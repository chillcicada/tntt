#let committee(
  // from entry
  anonymous: false,
  twoside: false,
  doctype: "master",
  fonts: (:),
  // options
  title: [学位论文指导小组、公开评阅人和答辩委员会名单],
  outlined: false,
  bookmarked: true,
  supervisors: (),
  reviewers: (),
  defenders: (:),
  defenders-items: (chairman: "主席", member: "委员", secretary: "秘书"),
) = {
  if anonymous or doctype not in ("master", "doctor", "postdoc") { return }

  import "../utils/page.typ": use-twoside
  import "../utils/font.typ": _use-fonts, use-size

  let use-fonts = name => _use-fonts(fonts, name)
  let format-text = str => {
    v(20pt)
    text(size: use-size("小三"), font: use-fonts("HeiTi"), str)
    v(2pt)
  }

  use-twoside(twoside)

  set align(center)
  set par(justify: false) // disable full justify
  set grid(row-gutter: 1em, align: horizon)

  heading(level: 1, numbering: none, outlined: outlined, bookmarked: bookmarked, title)

  v(2pt)

  format-text("指导小组名单")
  grid(columns: (3cm, 3cm, 9cm), ..supervisors.flatten())

  format-text("公开评阅人名单")
  grid(columns: (3cm, 3cm, 9cm), ..reviewers.flatten())

  format-text("答辩委员会名单")
  grid(columns: (2.75cm, 2.98cm, 4.63cm, 4.63cm), ..defenders-items
      .keys()
      .map(k => (defenders-items.at(k), defenders.at(k).intersperse("")))
      .flatten())
}
