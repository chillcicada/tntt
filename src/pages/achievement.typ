/// Achievement Page
///
/// - anonymous (bool): Whether to use anonymous mode.
/// - twoside (bool | str): Whether to use two-sided layout.
/// - degree (str): The degree.
/// - fonts (dictionary): The font family to use.
/// - title (content): The title of the achievement page.
/// - outlined (bool): Whether to outline the page.
/// - bookmarked (bool): Whether to add a bookmark for the page.
/// - resume (content): The resume content.
/// - paper (content): The list of papers.
/// - patent (content): The list of patents.
/// -> content
#let achievement(
  // from entry
  anonymous: false,
  twoside: false,
  degree: "bachelor",
  fonts: (:),
  // options
  title: [],
  outlined: true,
  bookmarked: true,
  resume: [],
  paper: [],
  patent: [],
) = {
  if anonymous { return }

  import "../utils/font.typ": _use-cjk-fonts, _use-fonts, use-size
  import "../utils/page.typ": use-twoside
  import "../utils/util.typ": is-not-empty

  let use-fonts = name => _use-fonts(fonts, name)
  let preset-title = (
    "bachelor": [在学期间参加课题的研究成果],
    "graduate": [个人简历、在学期间完成的相关学术成果],
  )

  title = if is-not-empty(title) { title } else {
    if degree == "bachelor" { preset-title.bachelor } else { preset-title.graduate }
  }

  /// Render Page
  use-twoside(twoside)

  heading(level: 1, numbering: none, outlined: outlined, bookmarked: bookmarked, title)

  if degree != "bachelor" {
    align(center, text(font: use-fonts("HeiTi"), size: use-size("四号"))[个人简历])

    v(8pt)

    resume

    if is-not-empty(paper) or is-not-empty(patent) {
      v(8pt)

      par[]

      align(center, text(font: use-fonts("HeiTi"), size: use-size("四号"))[在学期间完成的相关学术成果])

      v(1.7em)
    }
  }

  set par(first-line-indent: 0pt, leading: 8pt)
  set enum(indent: 0pt, numbering: "[1]", body-indent: 1.2em, spacing: 1.14em)

  if is-not-empty(paper) {
    text(font: use-fonts("HeiTi"), size: use-size("四号"))[学术论文：]

    v(1pt)

    paper

    par[]

    v(9pt)
  }

  if is-not-empty(patent) {
    text(font: use-fonts("HeiTi"), size: use-size("四号"))[专利：]

    v(1pt)

    patent
  }
}
