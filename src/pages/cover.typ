/// Cover Page
///
/// - anonymous (bool): Whether to use anonymous mode
/// - fonts (dictionary): The font family to use.
/// - info (dictionary): The information to be displayed on the cover page.
/// - title (str): The title of the cover page
/// - margin (margin): The margin settings for the cover page
/// - grid-columns (array): The widths of the grid columns
/// - grid-align (array): The alignment of each column in the grid
/// - column-gutter (length): The gutter between columns in the grid
/// - row-gutter (length): The gutter between rows in the grid
/// - info-keys (array): The keys to be displayed in the info section, in the order they should appear
/// - info-items (dictionary): The items to be displayed in the info section, mapping keys to their display names
/// - info-sperator (str): The separator between the info keys and items
/// - supervisor-sperator (str): The separator between the supervisor name and position
/// - title-font ("SongTi" | "HeiTi" | "KaiTi" | "FangSong" | "Mono" | "Math"): The font for the title
/// - body-font ("SongTi" | "HeiTi" | "KaiTi" | "FangSong" | "Mono" | "Math"): The font for the body text
/// - back-font ("SongTi" | "HeiTi" | "KaiTi" | "FangSong" | "Mono" | "Math"): The font for the back text
/// - author-width (length): The distribution width of the author name
/// - supervisor-width (length): The distribution width of the supervisor name and position
/// -> content
#let cover(
  // from entry
  anonymous: false,
  fonts: (:),
  info: (:),
  degree: "bachelor",
  degree-type: "academic",
  // options
  content: [],
  grid-align: (center, left, left),
  column-gutter: -3pt,
  row-gutter: 20.2pt,
  info-items: auto,
  author-width: 4em,
  supervisor-width: 8em,
) = {
  /// Import utilities
  import "../utils/font.typ": _use-cjk-fonts, _use-fonts, use-size
  import "../utils/text.typ": distr-text, space-text
  import "../utils/util.typ": display-zh, is-not-empty

  /// Prepare info
  let use-fonts = name => _use-fonts(fonts, name)
  let use-cjk-fonts = name => _use-cjk-fonts(fonts, name)

  if info-items == auto {
    info-items = if degree == "bachelor" {
      (department: "系别", major: "专业", author: "姓名", supervisor: "指导教师")
    } else if degree == "master" {
      (department: "培养单位", major: "学科", author: "研究生", supervisor: "指导教师")
    }
  }

  // Calculate suitable width of info items
  let info-item-width = calc.max(..info-items.values().map(v => v.clusters().len())) * 1em

  let use-anonymous(s, w) = if anonymous {
    // use the outset shift to fix the font baseline shift issue
    block(width: w, fill: black, "", outset: (y: 2pt))
  } else { distr-text(s, width: w) }

  info.author = use-anonymous(info.author, author-width)
  // @typstyle off
  info.supervisor = info.supervisor.chunks(2).intersperse("")
    .map(p => if p == "" { ("", "") } else { use-anonymous(p.join(" "), supervisor-width) })

  let format-info(items) = place(bottom + center, dy: -17em, text(
    size: use-size("三号"),
    font: use-cjk-fonts("FangSong"),
    grid(
      align: (center, left, left),
      columns: (2.80cm, 0.84cm, 5.62cm),
      rows: 1.09cm,
      ..(department: "系别", major: "专业", author: "姓名", supervisor: "指导教师")
        .keys()
        .map(k => (distr-text(info-items.at(k), width: info-item-width), "：", info.at(k, default: "")))
        .flatten()
    ),
  ))

  /// Render cover page
  set align(center)

  let preset-content = (
    bachelor: {
      set page(margin: (top: 3.8cm, bottom: 3.2cm, x: 3cm))

      v(2em)

      image("../assets/logo.png", width: 7.81cm)

      v(-1em)

      text(size: use-size("小初"), font: use-fonts("HeiTi"), weight: "bold", space-text("综合论文训练"))

      par[]

      text(size: use-size("一号"), font: use-fonts("HeiTi"), info.title)

      place(bottom + center, dy: -17em, text(size: use-size("三号"), font: use-cjk-fonts("FangSong"), grid(
        align: (center, left, left),
        columns: (2.80cm, 0.84cm, 5.62cm),
        rows: 1.09cm,
        ..(department: "系别", major: "专业", author: "姓名", supervisor: "指导教师")
          .keys()
          .map(k => (distr-text(info-items.at(k), width: info-item-width), "：", info.at(k, default: "")))
          .flatten()
      )))

      place(bottom + center, dy: -5em, text(size: use-size("三号"), font: use-cjk-fonts("SongTi"), display-zh(
        info.submit-date,
      )))
    },
    master: {
      set page(margin: (x: 4cm, y: 6cm))
      set par(leading: 1.15em, spacing: 1.3em)
      v(7em)
      text(size: use-size("一号"), font: use-fonts("HeiTi"), info.title)
      parbreak()
      text(size: use-size("小二"), font: use-fonts("SongTi"), [（申请清华大学工学硕士学位论文）])
    },
  )

  if is-not-empty(content) { content } else { preset-content.at(degree, default: content) }
}

#let cover-en(
  anonymous: false,
  fonts: (:),
  info: (:),
  degree: "master",
  twoside: false,
) = {
  if degree not in ("master", "doctor", "postdoc") { return }

  import "../utils/page.typ": use-twoside

  use-twoside(twoside)

  info.submit-date.display("[month repr:long], [year]")
}
