#!/usr/bin/env -S typst c
// #import "@preview/tntt:0.5.4" as tntt
#import "../src/lib.typ" as tntt

#let font-family = (
  SongTi: ((name: "TeX Gyre Termes", covers: "latin-in-cjk"), "FandolSong"),
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
  copyright,
  abstract,
  abstract-en,
  outline-wrapper,
  bilingual-bibliography,
  acknowledge,
  declaration,
) = tntt.define-config(
  lang: "zh",
  degree: "master",
  degree-type: "academic",
  anonymous: false,
  twoside: false,
  info: (
    title: "论文题目",
    author: "作者姓名",
    date: datetime.today(),
  ),
  bibliography: read("main.bib"),
  fonts: font-family,
)

#show: it => meta(it)

#cover(info: (
  department: "院系名称",
  major: "学科名称",
  degree-name: "工学硕士",
  supervisor: ("导师姓名", "教授"),
))

#cover-en(info: (
  title: "Thesis Title",
  author: "Author Name",
  major: "Discipline",
  degree-name: "Master of Engineering",
  supervisor: ("Professor Name",),
  co-supervisor: (),
))

#show: it => doc(it)
#copyright()

#show: it => front-matter(it)

#abstract(keywords: ("关键词一", "关键词二"))[
  中文摘要概括论文的问题、方法、主要结果和结论。
]

#abstract-en(keywords: ("keyword one", "keyword two"))[
  The abstract states the problem, method, principal results, and conclusion.
]

#outline-wrapper()

#show: it => main-matter(it)

#if config.lang == "zh" [
  = 引言

  在此撰写论文正文，并使用标签引用文献 @knuth1984。
] else [
  = Introduction

  Write the thesis body here and cite sources with labels @knuth1984.
]

#show: it => back-matter(it)

#bilingual-bibliography(full: false)

#acknowledge(if config.lang == "zh" [在此感谢对本研究提供帮助的个人和机构。] else [
  Acknowledge the people and institutions that supported this research.
])

#declaration()
