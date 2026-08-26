// #import "@preview/tntt:0.5.4" as tntt
#import "../src/lib.typ" as tntt
#import "abstract.typ": render-abstract
#import "acknowledgements-en.typ": acknowledgements-content
#import "comments-en.typ": comments-content
#import "notation-en.typ": denotation-entries
#import "resolution-en.typ": resolution-content

// This entrypoint intentionally uses the TnTT 0.5.x page-level API. The
// LaTeX-aligned instance API is introduced together with the new core later.
#let font-family = (
  SongTi: (
    (name: "TeX Gyre Termes", covers: "latin-in-cjk"),
    "FandolSong",
    "FandolKai",
  ),
  HeiTi: ((name: "TeX Gyre Heros", covers: "latin-in-cjk"), "FandolHei"),
  KaiTi: ((name: "TeX Gyre Termes", covers: "latin-in-cjk"), "FandolKai"),
  FangSong: ((name: "TeX Gyre Termes", covers: "latin-in-cjk"), "FandolFang R"),
  Mono: ((name: "TeX Gyre Cursor", covers: "latin-in-cjk"), "FandolFang R"),
  Math: ("XITS Math", "FandolKai"),
)

#let (
  ..config,
  use-en-font,
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
    title: (
      "Tsinghua University Typst Thesis Template",
      "Sample Document v0.1.0",
    ),
    author: "Xue Ruini",
    date: datetime(year: 2026, month: 8, day: 8),
  ),
  bibliography: read("main.bib"),
  fonts: font-family,
)

#show: it => meta(it, lang: "en", region: "us", use-fakebold: false)

#cover(info: (
  department: "Department of Computer Science and Technology",
  major: "Computer Science and Technology",
  degree-name: "Master of Science",
  supervisor: ("Zheng Weimin", "Professor"),
  co-supervisor: ("Chen Wenguang", "Professor"),
))

#cover-en(info: (
  title: "An Introduction to the Typst Thesis Template of Tsinghua University",
  author: "Xue Ruini",
  major: "Computer Science and Technology",
  degree-name: "Master of Science",
  supervisor: ("Professor Zheng Weimin",),
  co-supervisor: ("Professor Chen Wenguang",),
))

#show: it => doc(it)
#set text(font: use-en-font("SongTi"), lang: "en", region: "us")

#committee(
  supervisors: (
    ("Li XX", "Professor", "Tsinghua University"),
    ("Wang XX", "Associate Professor", "Tsinghua University"),
    ("Zhang XX", "Assistant Professor", "Tsinghua University"),
  ),
  reviewers: (),
  defenders: (
    Chair: (("Zhao XX", "Professor", "Tsinghua University"),),
    Members: (
      ("Liu XX", "Professor", "Tsinghua University"),
      (
        "Yang XX",
        "Research Professor",
        "Institute XXXXXXX, Chinese Academy of Sciences",
      ),
    ),
    Secretary: (
      ("Wu XX", "Assistant Research Professor", "Tsinghua University"),
    ),
  ),
)

#copyright()

#show: it => front-matter(it)

#render-abstract(abstract, abstract-en)
#outline-wrapper(title: [Contents])
#figure-list(title: [List of Figures])
#table-list(title: [List of Tables])
#notation(title: [Nomenclature])[
  #for (term, description) in denotation-entries {
    terms.item(term, description)
  }
]

#show: it => main-matter(
  it,
  heading-numbering: (formats: ("1", "1.1"), depth: 4, supplyment: " "),
)

#include "writing-en.typ"
#include "figures-en.typ"
#include "mathematics-en.typ"
#include "citations-en.typ"

#show: it => back-matter(
  it,
  heading-numbering: (
    formats: ("Appendix A", "A.1"),
    depth: 4,
    supplyment: " ",
  ),
)

#bilingual-bibliography(title: [References])
#include "appendix-en.typ"

#acknowledge(title: [Acknowledgements])[#acknowledgements-content]
#declaration()
#achievement(
  resume: [Born in a county in Sichuan Province on Month ×, 197×.],
  paper: [
    1. Yang Y, Ren T L, Zhang L T, et al. Miniature microphone with silicon-based
    ferroelectric thin films[J]. Integrated Ferroelectrics, 2003, 52:229-235.
  ],
  patent: [
    1. Ren T L, Yang Y, Zhu Y P, et al. Method for controlling domain-polarized
    regions and connecting electrodes in a silicon-based ferroelectric
    microacoustic sensor[P].
  ],
)
#comments(title: [Comments from the Thesis Supervisor])[#comments-content]
#resolution[#resolution-content]
