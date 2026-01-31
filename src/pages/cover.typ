/// Cover Page
///
/// - anonymous (bool): Whether to use anonymous mode.
/// - fonts (dictionary): The font family to use.
/// - info (dictionary): The information to be displayed on the cover page.
/// - degree (str): The degree.
/// - degree-type (str): The type of degree.
/// - info-items (dictionary): The items to be displayed in the info section, mapping keys to their display names.
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
  info-items: (:),
) = {
  import "../utils/font.typ": _use-cjk-fonts, _use-fonts, use-size
  import "../utils/text.typ": distr-text, fixed-text, space-text
  import "../utils/util.typ": display-zh, is-not-empty

  let use-fonts = name => _use-fonts(fonts, name)
  let use-cjk-fonts = name => _use-cjk-fonts(fonts, name)
  let use-anonymous = width => block(width: width, fill: black, "", outset: (y: 2pt))

  // @typstyle off
  let preset-info-items = (
    bachelor: (department: "系别", major: "专业", author: "姓名", supervisor: "指导教师"),
    graduate: (department: "培养单位", major: "学科", author: "研究生", supervisor: "指导教师", co-supervisor: "联合指导教师"),
  )

  if info-items == (:) {
    info-items = if degree == "bachelor" { preset-info-items.bachelor } else { preset-info-items.graduate }
  }

  assert(info-items.keys().all(k => info.keys().contains(k)), message: "Some info-items keys are missing in info.")

  // Calculate suitable width of info items
  let info-item-width = if degree == "bachelor" { 4em } else { 5em }
  let format-info-item(it) = block(width: info-item-width, fixed-text(it, info-item-width))

  info.supervisor = info.supervisor.chunks(2)
  if degree != "bachelor" { info.co-supervisor = info.co-supervisor.chunks(2) }

  // Calculate suitable width of supervisor
  let supervisor-width = {
    let name-width = calc.max(
      info.author.clusters().len(),
      ..info.supervisor.map(p => p.first().clusters().len()),
      ..if degree != "bachelor" { info.co-supervisor.map(p => p.first().clusters().len()) },
    )
    let post-width = calc.max(
      ..info.supervisor.map(p => p.last().clusters().len()),
      ..if degree != "bachelor" { info.co-supervisor.map(p => p.last().clusters().len()) },
    )

    if name-width <= 3 and post-width >= 4 { (3em, (post-width + 1) * 1em) } else {
      (calc.max(4, name-width) * 1em, calc.max(4, post-width + 1) * 1em)
    }
  }

  // TODO: add pretty formatting
  info.author = if anonymous { use-anonymous(4em) } else {
    block(fixed-text(info.author, supervisor-width.first()), width: supervisor-width.first())
  }

  let format-supervisor(arr) = arr
    .intersperse("")
    .map(p => if p == "" { ("", "") } else {
      if anonymous { use-anonymous(8em) } else {
        block(
          fixed-text(p.first(), supervisor-width.first()) + fixed-text("　" + p.last(), supervisor-width.last()),
          width: supervisor-width.sum(),
        )
      }
    })
  info.supervisor = format-supervisor(info.supervisor)

  if degree != "bachelor" { info.co-supervisor = format-supervisor(info.co-supervisor) }

  if type(info.title) == str { info.title = info.title.split("\n") }

  let placed-content(content, dy) = place(bottom + center, content, dy: dy)
  let format-info(items) = grid(
    align: (center, left, left), rows: 1.09cm, columns: (2.80cm, 0.82cm, 5.62cm),
    ..items.keys().map(k => (format-info-item(items.at(k)), ": ", info.at(k))).flatten()
  )

  let preset-content = (
    bachelor: {
      set page(margin: (top: 3.8cm, bottom: 3.2cm, x: 3cm))
      set par(leading: 1.15em, spacing: 1.3em)
      v(2em)
      image("../assets/logo.png", width: 7.81cm)
      v(-1em)
      text(size: use-size("小初"), font: use-fonts("HeiTi"), weight: "bold", space-text("综合论文训练"))
      par[]
      text(size: use-size("一号"), font: use-fonts("HeiTi"), info.title.join("\n"))
      placed-content(text(size: use-size("三号"), font: use-cjk-fonts("FangSong"), format-info(info-items)), -17em)
      placed-content(text(size: use-size("三号"), font: use-cjk-fonts("SongTi"), display-zh(info.date)), -5em)
    },
    graduate: {
      set page(margin: (x: 4cm, y: 6cm))
      set par(leading: 1.15em, spacing: 1.3em)
      v(1.2em)
      text(size: use-size("一号"), font: use-fonts("HeiTi"), info.title.join("\n"))
      parbreak()
      text(size: use-size("小二"), font: use-fonts("SongTi"), [（申请清华大学#info.degree-name;学位论文）])
      placed-content(text(size: use-size("三号"), font: use-cjk-fonts("FangSong"), format-info(info-items)), -7.5em)
      placed-content(text(size: use-size("三号"), font: use-cjk-fonts("SongTi"), display-zh(info.date)), -0.9em)
    },
  )

  /// Render cover page
  set align(center)

  if is-not-empty(content) { content } else {
    if degree == "bachelor" { preset-content.bachelor } else { preset-content.graduate }
  }
}

/// English Cover Page
#let cover-en(
  // from entry
  anonymous: false,
  fonts: (:),
  info: (:),
  degree: "master",
  twoside: false,
  // options
  info-items: (supervisor: "Thesis Supervisor", co-supervisor: "Associate Supervisor"),
) = {
  if degree not in ("master", "doctor", "postdoc") { return }

  import "../utils/page.typ": use-twoside
  import "../utils/font.typ": _use-fonts, use-size

  let use-fonts = name => _use-fonts(fonts, name)
  let use-anonymous = width => block(width: width, fill: black, "", outset: (y: 2pt))

  assert(info-items.keys().all(k => info.keys().contains(k)), message: "Some info-items keys are missing in info.")

  let placed-content(content, dy) = place(bottom + center, content, dy: dy)
  let format-supervisor(items) = grid(
    align: (right, left), columns: (5.95cm, 1fr), rows: 1.1cm, column-gutter: 9.5pt,
    ..items
      .keys()
      .map(k => (items.at(k) + " : ", if anonymous { use-anonymous(10em) } else { info.at(k).intersperse("") }))
      .flatten()
  )

  if type(info.title) == str { info.title = info.title.split("\n") }

  /// Render cover page
  use-twoside(twoside)

  set align(center)
  set page(margin: (x: 4cm, y: 5.8cm))
  set text(size: use-size("三号"))

  text(size: use-size("二号"), font: use-fonts("HeiTi"), strong(info.title.join("\n")))

  placed-content(
    {
      set par(leading: 1em, spacing: 1.05em)
      set text(font: use-fonts("SongTi"))
      [
        Thesis submitted to

        *Tsinghua University*

        in partial fulfillment of the requirement

        for the degree of
      ]
      v(-0.4pt)
      strong(text(font: use-fonts("HeiTi"), info.degree-name))
      v(3pt)
      [in]
      v(3pt)
      strong(text(font: use-fonts("HeiTi"), info.major))
    },
    -11.64em,
  )

  placed-content(
    {
      set text(font: use-fonts("HeiTi"))
      [by]
      v(3pt)
      strong(if anonymous { use-anonymous(5em) } else { info.author })
      v(-21pt)
      text(font: use-fonts("SongTi"), tracking: -0.45pt, format-supervisor(info-items))
    },
    -2.56em,
  )

  placed-content(strong(text(font: use-fonts("HeiTi"), info.date.display("[month repr:long], [year]"))), 3pt)
}
