#import "../utils/font.typ": use-size, trim-en
#import "../utils/text.typ": space-text

/// Cover Page
#let cover(
  // from entry
  anonymous: false,
  fonts: (:),
  info: (:),
  // options
  cover-title: "综合论文训练",
  column-gutter: -3pt,
  row-gutter: 16pt,
  anonymous-info-keys: ("author", "supervisor"),
) = {
  set page(margin: (top: 3.8cm, bottom: 3.2cm, x: 3cm))

  set align(center)

  set text(font: trim-en(fonts.at("HeiTi")))

  image("../assets/logo.png", width: 7.81cm)

  v(-1em)

  text(size: use-size("小初"), weight: "bold", space-text(cover-title, spacing: " "))

  v(1em)

  text(size: use-size("一号"), info.title)

  set text(size: use-size("三号"), font: trim-en(fonts.at("FangSong")))

  v(6em)

  block(
    width: 2.80cm + 0.82cm + 5.62cm,
    grid(
      columns: (2.80cm, 0.82cm, 5.62cm),
      align: (center, left, left),
      column-gutter: column-gutter,
      row-gutter: row-gutter,
      // content below
      "系　　别", "：", info.department,
      "专　　业", "：", info.major,
      "姓　　名", "：", space-text(info.author),
      "指导教师", "：", space-text(info.supervisor.at(0)) + "　" + space-text(info.supervisor.at(1)),
    ),
  )

  v(6em)

  text(font: trim-en(fonts.at("SongTi")), info.submit-date)
}
