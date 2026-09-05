#!/usr/bin/env -S typst c
// Published packages use the first import. Repository builds use the second.
// #import "@preview/tntt:0.6.0" as tntt
#import "../src/lib.typ" as tntt

// Replace these open fonts if your institution requires another font set.
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
  // 论文语言 / Thesis language: "zh" or "en".
  // The CLI can override this with `--input lang=en`.
  lang: "zh",
  // `auto` selects "cn" for Chinese and "us" for English.
  region: auto,
  // 学位层级 / Degree: "bachelor", "master", "doctor", or "postdoc".
  degree: "master",
  degree-type: "academic",
  // Anonymous review hides author information and applicable back matter.
  anonymous: false,
  // Enable this for a thesis intended for two-sided printing.
  twoside: false,
  // This information is also written to the PDF metadata.
  info: (
    title: "论文题目",
    author: "作者姓名",
    date: datetime.today(),
  ),
  // Keep bibliography files next to the entrypoint or update this path.
  bibliography: read("main.bib"),
  fonts: font-family,
)

// Apply PDF metadata, language, paper size, and global reference behavior.
#show: it => meta(it)

// The Chinese cover is required for both Chinese and English theses.
#cover(info: (
  department: "院系名称",
  major: "学科名称",
  degree-name: "工学硕士",
  supervisor: ("导师姓名", "教授"),
))

// This page is omitted automatically for degree types that do not require it.
#cover-en(info: (
  title: "Thesis Title",
  author: "Author Name",
  major: "Discipline",
  degree-name: "Master of Engineering",
  supervisor: ("Professor Name",),
  co-supervisor: (),
))

// Apply the common typography before emitting the remaining pages.
#show: it => doc(it)
#copyright()

// Front matter uses Roman page numbering where required.
#show: it => front-matter(it)

#abstract(keywords: ("关键词一", "关键词二"))[
  中文摘要概括论文的问题、方法、主要结果和结论。
]

#abstract-en(keywords: ("keyword one", "keyword two"))[
  The abstract states the problem, method, principal results, and conclusion.
]

#outline-wrapper()

// Main matter resets heading and page numbering.
#show: it => main-matter(it)

#if config.lang == "zh" [
  = 引言

  在此撰写论文正文，并使用标签引用文献 @knuth1984。
] else [
  = Introduction

  Write the thesis body here and cite sources with labels @knuth1984.
]

#show: it => back-matter(it)

// Pass `style: "gb-7714-2015-author-date"` for author-date citations.
// Pass `full: true` when uncited bibliography entries must also be printed.
#bilingual-bibliography(full: false)

#acknowledge(if config.lang == "zh" [在此感谢对本研究提供帮助的个人和机构。] else [
  Acknowledge the people and institutions that supported this research.
])

#declaration()
