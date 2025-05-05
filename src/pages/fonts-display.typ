#import "../utils/font.typ": font-size

// 字体显示测试页
#let fonts-display(
  twoside: false,
  fonts: (:),
  size: font-size.小四,
) = {
  // 辅助函数
  let display-font(cjk-name, latin-name) = [
    #line(length: 100%)

    #set text(font: fonts.at(latin-name))

    #cjk-name (#latin-name CJK Regular): 落霞与孤鹜齐飞，秋水共长天一色。

    #cjk-name (#latin-name Latin Regular): The fanfare of birds announces the morning.

    *#cjk-name (#latin-name CJK Bold): 落霞与孤鹜齐飞，秋水共长天一色。*

    *#cjk-name (#latin-name Latin Bold): The fanfare of birds announces the morning.*
  ]

  // 正式渲染
  pagebreak(weak: true, to: if twoside { "odd" })
  set text(size: size, font: fonts.SongTi)

  [
    *Fonts Display Page | Adjust the font configuration to render correctly in the PDF*

    *字体展示页 | 请调整字体配置至正确在 PDF 中渲染*
  ]

  let font-list = (
    ("宋体", "SongTi"),
    ("黑体", "HeiTi"),
    ("楷体", "KaiTi"),
    ("仿宋", "FangSong"),
    ("等宽", "Mono"),
  )

  for it in font-list { display-font(..it) }
}
