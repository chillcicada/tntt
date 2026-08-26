// #import "@preview/tntt:0.5.4" as tntt
#import "../src/lib.typ" as tntt
#import "abstract.typ": render-abstract
#import "acknowledgements.typ": acknowledgements-content
#import "comments.typ": comments-content
#import "notation.typ": denotation-entries
#import "resolution.typ": resolution-content

// This entrypoint intentionally uses the TnTT 0.5.x page-level API. The
// LaTeX-aligned instance API is introduced together with the new core later.
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
  committee,
  copyright,
  abstract,
  abstract-en,
  outline-wrapper,
  figure-list,
  table-list,
  notation,
  bilingual-bibliography,
  acknowledge,
  declaration,
  achievement,
  comments,
  resolution,
) = tntt.define-config(
  degree: "master",
  degree-type: "academic",
  anonymous: false,
  twoside: false,
  info: (
    title: ("清华大学学位论文 Typst 模板", "使用示例文档 v0.1.0"),
    author: "薛瑞尼",
    date: datetime(year: 2026, month: 8, day: 8),
  ),
  bibliography: read("main.bib"),
  fonts: font-family,
)

#show: it => meta(it)

#cover(info: (
  department: "计算机科学与技术系",
  major: "计算机科学与技术",
  degree-name: "工学硕士",
  supervisor: ("郑纬民", "教授"),
  co-supervisor: ("陈文光", "教授"),
))

#cover-en(info: (
  title: "An Introduction to Typst Thesis Template of Tsinghua University",
  author: "Xue Ruini",
  major: "Computer Science and Technology",
  degree-name: "Master of Science",
  supervisor: ("Professor Zheng Weimin",),
  co-supervisor: ("Professor Chen Wenguang",),
))

#show: it => doc(it)

#committee(
  supervisors: (
    ("李XX", "教授", "清华大学"),
    ("王XX", "副教授", "清华大学"),
    ("张XX", "助理教授", "清华大学"),
  ),
  reviewers: (),
  defenders: (
    主席: (("赵XX", "教授", "清华大学"),),
    委员: (
      ("刘XX", "教授", "清华大学"),
      ("杨XX", "研究员", "中国XXXX科学院XXXXXXX研究所"),
    ),
    秘书: (("吴XX", "助理研究员", "清华大学"),),
  ),
)

#copyright()

#show: it => front-matter(it)

#render-abstract(abstract, abstract-en)
#outline-wrapper()
#figure-list()
#table-list()
#notation[
  #for (term, description) in denotation-entries {
    terms.item(term, description)
  }
]

#show: it => main-matter(it)

#include "writing.typ"
#include "figures.typ"
#include "mathematics.typ"
#include "citations.typ"

#show: it => back-matter(it)

#bilingual-bibliography()
#include "appendix.typ"

#acknowledge[#acknowledgements-content]
#declaration()
#achievement(
  resume: [197× 年 ×× 月 ×× 日出生于四川××县。],
  paper: [
    1. Yang Y, Ren T L, Zhang L T, et al. Miniature microphone with silicon-based
    ferroelectric thin films[J]. Integrated Ferroelectrics, 2003, 52:229-235.
  ],
  patent: [
    1. 任天令, 杨轶, 朱一平, 等. 硅基铁电微声学传感器畴极化区域控制和电极连接的方法[P].
  ],
)
#comments[#comments-content]
#resolution[#resolution-content]
