/// Cover Page
///
/// - anonymous (bool): Whether to use anonymous mode.
/// - fonts (dictionary): The font family to use.
/// - info (dictionary): The information to be displayed on the cover page.
/// - degree (str): The degree.
/// - degree-type (str): The type of degree.
/// - info-items (dictionary): The items to be displayed in the info section, mapping keys to their display names.
/// - info-separator (str): The separator between info item name and value.
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
  info-items: auto,
  info-separator: ": ",
  info-ailgn: auto,
  justified-width: auto,
) = {
  import "../utils/font.typ": _use-cjk-fonts, _use-fonts, use-size
  import "../utils/text.typ": distr-text, space-text
  import "../utils/util.typ": display-zh, is-not-empty

  let use-fonts = name => _use-fonts(fonts, name)
  let use-cjk-fonts = name => _use-cjk-fonts(fonts, name)

  // @typstyle off
  let preset-info-items = (
    bachelor: (department: "系别", major: "专业", author: "姓名", supervisor: "指导教师"),
    graduate: (department: "培养单位", major: "学科", author: "研究生", supervisor: "指导教师", co-supervisor: "联合指导教师"),
  )

  if info-items == auto {
    info-items = if degree == "bachelor" { preset-info-items.bachelor } else { preset-info-items.graduate }
  }

  assert(info-items.keys().all(k => info.keys().contains(k)), message: "Some info-items keys are missing in info.")

  // Calculate suitable width of info items
  let info-item-width = calc.max(..info-items.values().map(v => v.clusters().len())) * 1em

  let use-anonymous(s, w) = if anonymous {
    // use the outset shift to fix the font baseline shift issue
    block(width: w, fill: black, "", outset: (y: 2pt))
  } else { distr-text(s, width: w) }

  info.author = use-anonymous(info.author, 4em)
  // @typstyle off
  info.supervisor = info.supervisor.chunks(2).intersperse("")
    .map(p => if p == "" { ("", "") } else { use-anonymous(p.join(" "), 8em) })
  if degree != "bachelor" {
    // @typstyle off
    info.co-supervisor = info.co-supervisor.chunks(2).intersperse("")
      .map(p => if p == "" { ("", "") } else { use-anonymous(p.join(" "), 8em) })
  }

  let placed-content(content, dy) = place(bottom + center, content, dy: dy)
  let format-info(items) = grid(
    align: (center, left, left), rows: 1.09cm, columns: (2.80cm, 0.82cm, 5.62cm),
    ..items.keys().map(k => (distr-text(items.at(k), width: 5em), info-separator, info.at(k))).flatten()
  )

  let preset-content = (
    bachelor: {
      set page(margin: (top: 3.8cm, bottom: 3.2cm, x: 3cm))
      set par() // TODO
      v(2em)
      image("../assets/logo.png", width: 7.81cm)
      v(-1em)
      text(size: use-size("小初"), font: use-fonts("HeiTi"), weight: "bold", space-text("综合论文训练"))
      par[]
      text(size: use-size("一号"), font: use-fonts("HeiTi"), info.title)
      placed-content(text(size: use-size("三号"), font: use-cjk-fonts("FangSong"), format-info(info-items)), -17em)
      placed-content(text(size: use-size("三号"), font: use-cjk-fonts("SongTi"), display-zh(info.submit-date)), -5em)
    },
    graduate: supplyment => {
      set page(margin: (x: 4cm, y: 6cm))
      set par(leading: 1.15em, spacing: 1.3em)
      text(size: use-size("一号"), font: use-fonts("HeiTi"), info.title)
      parbreak()
      text(size: use-size("小二"), font: use-fonts("SongTi"), supplyment)
      placed-content(text(size: use-size("三号"), font: use-cjk-fonts("FangSong"), format-info(info-items)), -17em)
      placed-content(text(size: use-size("三号"), font: use-cjk-fonts("SongTi"), display-zh(info.submit-date)), -5em)
    },
  )

  /// Render cover page
  set align(center)

  if is-not-empty(content) { content } else {
    if degree == "bachelor" { preset-content.bachelor } else { (preset-content.graduate)([test]) }
  }
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
  import "../utils/font.typ": _use-fonts, use-size

  let use-fonts = name => _use-fonts(fonts, name)

  /// Render cover page
  use-twoside(twoside)

  info.submit-date.display("[month repr:long], [year]")
}
