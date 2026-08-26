#import "../../src/lib.typ" as thu

#let degree = sys.inputs.at("degree")
#let output = sys.inputs.at("output")
#let degree-type = sys.inputs.at("degree-type")

#let font-family = (
  SongTi: ((name: "TeX Gyre Termes", covers: "latin-in-cjk"), "FandolSong", "FandolKai"),
  HeiTi: ((name: "TeX Gyre Heros", covers: "latin-in-cjk"), "FandolHei"),
  KaiTi: ((name: "TeX Gyre Termes", covers: "latin-in-cjk"), "FandolKai"),
  FangSong: ((name: "TeX Gyre Termes", covers: "latin-in-cjk"), "FandolFang R"),
  Mono: ((name: "TeX Gyre Cursor", covers: "latin-in-cjk"), "FandolFang R"),
  Math: ("XITS Math", "FandolKai"),
)

#let (
  ..config,
  meta,
  doc,
  front-matter,
  main-matter,
  back-matter,
  cover,
  cover-en,
  abstract,
  abstract-en,
  outline-wrapper,
) = thu.define-config(
  degree: degree,
  degree-type: degree-type,
  twoside: output == "print",
  fonts: font-family,
  info: (
    title: "论文模板视觉对比",
    author: "测试作者",
    date: datetime(year: 2026, month: 8, day: 8),
  ),
)

#show: it => meta(it)

#cover(info: (
  department: "计算机科学与技术系",
  major: "计算机科学与技术",
  degree-name: "工学学位",
  supervisor: ("测试导师", "教授"),
))

#cover-en(info: (
  title: "Visual Comparison of Thesis Templates",
  author: "Test Author",
  major: "Computer Science and Technology",
  degree-name: "Degree of Engineering",
  supervisor: ("Professor Test Supervisor",),
  co-supervisor: (),
))

#show: it => doc(it)

#show: it => front-matter(it)

#abstract(keywords: ("模板", "对比"))[
  本文用于比较 LaTeX 与 Typst 模板在不同论文配置下的版式。
]
#abstract-en(keywords: ("template", "comparison"))[
  This document compares the LaTeX and Typst layouts under different thesis
  configurations.
]
#outline-wrapper()

#show: it => main-matter(it)

= 比较章节

这是用于检查正文、页眉、页码和章节编号的示例文字。

== 图表与公式

#figure(rect(width: 3cm, height: 1cm), caption: [示例图])

$ E = m c^2 $

#show: it => back-matter(it)

= 附录测试

这是用于检查附录编号和页眉的示例文字。
