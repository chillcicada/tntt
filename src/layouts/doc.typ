#import "../imports.typ": cuti
#import cuti: show-cn-fakebold

#import "../utils/font.typ": use-size

#let meta(
  // from entry
  info: (:),
  // options
  lang: "zh",
  region: "cn",
  margin: (x: 89pt),
  fallback: false,
  // self
  it,
) = {
  // 1.  默认参数
  info = (
    (
      title: ("基于 Typst 的", "清华大学学位论文"),
      author: "张三",
    )
      + info
  )

  // 2.  对参数进行处理
  // 2.1 如果是字符串，则使用换行符将标题分隔为列表
  if type(info.title) == str {
    info.title = info.title.split("\n")
  }

  // 3.  基本的样式设置
  show: show-cn-fakebold

  set text(fallback: fallback, lang: lang, region: region)

  set page(margin: margin)

  // 4.  PDF 元信息
  set document(
    title: (("",) + info.title).sum(),
    author: info.author,
  )

  it
}

#let doc(
  // from entry
  fonts: (:),
  // options
  indent: 2em,
  justify: true,
  leading: 1.5 * 15.6pt - 0.7em,
  spacing: 1.5 * 15.6pt - 0.7em,
  code-block-leading: 1em,
  code-block-spacing: 1em,
  heading-size: "小三",
  body-size: "小四",
  fontnote-size: "五号",
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

  /// Heading
  show heading: set text(font: fonts.HeiTi, size: use-size(heading-size))

  show heading.where(level: 1): it => {
    set text(weight: "regular")
    align(center, it)
  }

  /// Body Text
  set text(font: fonts.SongTi, size: use-size(body-size))

  it
}
