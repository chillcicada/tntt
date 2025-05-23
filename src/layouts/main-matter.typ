#import "../utils/font.typ": use-size
#import "../utils/numbering.typ": custom-numbering
#import "../utils/heading.typ": heading-display, active-heading, current-heading

#import "../imports.typ": i-figured

#let main-matter(
  // from entry
  twoside: false,
  fonts: (:),
  // options
  page-numbering: "1",
  show-figure: i-figured.show-figure,
  show-equation: i-figured.show-equation,
  // TODO: remove this
  numbering: custom-numbering.with(first-level: "第一章 ", depth: 4, "1.1 "),
  heading-weight: ("regular",),
  heading-above: (2 * 15.6pt - 0.7em, 2 * 15.6pt - 0.7em),
  heading-below: (2 * 15.6pt - 0.7em, 1.5 * 15.6pt - 0.7em),
  heading-pagebreak: (true, false),
  heading-align: (center, auto),
  header-render: auto,
  header-vspace: 0em,
  display-header: false,
  skip-on-first-level: true,
  stroke-width: 0.5pt,
  reset-footnote: true,
  separator: "  ",
  caption-style: strong,
  caption-size: "五号",
  ..args,
  // self
  it,
) = {
  set page(numbering: page-numbering)

  show heading: i-figured.reset-counters

  show math.equation.where(block: true): show-equation

  show figure: show-figure
  show figure.where(kind: table): set figure.caption(position: top)
  set figure.caption(separator: separator)
  show figure.caption: caption-style
  show figure.caption: set text(font: fonts.SongTi, size: use-size(caption-size))

  let unpairs(pairs) = {
    let dict = (:)
    for pair in pairs {
      dict.insert(..pair)
    }
    dict
  }

  // 1.2 处理 heading- 开头的其他参数
  let heading-text-args-lists = args
    .named()
    .pairs()
    .filter(pair => pair.at(0).starts-with("heading-"))
    .map(pair => (pair.at(0).slice("heading-".len()), pair.at(1)))

  // 2.  辅助函数
  let array-at(arr, pos) = {
    arr.at(calc.min(pos, arr.len()) - 1)
  }

  // 4.  处理标题
  // 4.1 设置标题的 Numbering
  set heading(numbering: numbering)
  // 4.2 设置字体字号并加入假段落模拟首行缩进
  show heading: it => {
    set text(
      weight: array-at(heading-weight, it.level),
      ..unpairs(heading-text-args-lists.map(pair => (pair.at(0), array-at(pair.at(1), it.level)))),
    )
    set block(
      above: array-at(heading-above, it.level),
      below: array-at(heading-below, it.level),
    )
    it
  }
  // 4.3 标题居中与自动换页
  show heading: it => {
    if array-at(heading-pagebreak, it.level) {
      // 如果打上了 no-auto-pagebreak 标签，则不自动换页
      if "label" not in it.fields() or str(it.label) != "no-auto-pagebreak" {
        pagebreak(weak: true)
      }
    }
    if array-at(heading-align, it.level) != auto {
      set align(array-at(heading-align, it.level))
      it
    } else {
      it
    }
  }

  // 5.  处理页眉
  set page(..(
    if display-header {
      (
        header: context {
          // 重置 footnote 计数器
          if reset-footnote {
            counter(footnote).update(0)
          }
          let loc = here()
          // 5.1 获取当前页面的一级标题
          let cur-heading = current-heading(level: 1)
          // 5.2 如果当前页面没有一级标题，则渲染页眉
          if not skip-on-first-level or cur-heading == none {
            if header-render == auto {
              // 一级标题和二级标题
              let first-level-heading = if not twoside or calc.rem(loc.page(), 2) == 0 {
                heading-display(active-heading(level: 1, loc))
              } else { "" }
              let second-level-heading = if not twoside or calc.rem(loc.page(), 2) == 2 {
                heading-display(active-heading(level: 2, prev: false, loc))
              } else { "" }
              set text(font: fonts.KaiTi, size: use-size("五号"))
              stack(
                first-level-heading + h(1fr) + second-level-heading,
                v(0.25em),
                if first-level-heading != "" or second-level-heading != "" {
                  line(length: 100%, stroke: stroke-width + black)
                },
              )
            } else {
              header-render(loc)
            }
            v(header-vspace)
          }
        },
      )
    } else {
      (
        header: {
          // 重置 footnote 计数器
          if reset-footnote {
            counter(footnote).update(0)
          }
        },
      )
    }
  ))

  context {
    if calc.even(here().page()) {
      set page(numbering: "I", header: none)
      // counter(page).update(1)
      pagebreak() + " "
    }
  }

  counter(page).update(1)

  it
}
