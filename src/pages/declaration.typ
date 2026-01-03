/// Declaration Page
///
/// - anonymous (bool): Whether to use anonymous mode.
/// - twoside (bool): Whether to use two-sided layout.
/// - title (content): The title of the declaration page.
/// - outlined (bool): Whether to outline the page.
/// - bookmarked (bool): Whether to add a bookmark for the page.
/// - body (content): The body content of the declaration page.
/// - back-vspace (length): The vertical space after the body.
/// - back (content): The back text for signatures.
/// -> content
#let declaration(
  // from entry
  anonymous: false,
  twoside: false,
  doctype: "bachelor",
  // options
  title: [声　明],
  outlined: true,
  bookmarked: true,
  body: [],
  back-vspace: 38pt,
  back: "签  名：____________  日  期：____________",
) = {
  if anonymous { return }

  import "../utils/font.typ": use-size

  /// Render declaration page
  pagebreak(weak: true, to: if twoside { "odd" })

  heading(level: 1, numbering: none, outlined: outlined, bookmarked: bookmarked, title)

  if body not in (none, []) { body } else if doctype == "bachelor" {
    [
      本人郑重声明：所呈交的综合论文训练论文，是本人在导师指导下，独立进行研究工作所取得的成果。尽我所知，除文中已经注明引用的内容外，本论文的研究成果不包含任何他人享有著作权的内容。对本论文所涉及的研究工作做出贡献的其他个人和集体，均已在文中以明确方式标明。
    ]
  } else if doctype == "master" {
    [
      本人郑重声明：所呈交的学位论文，是本人在导师指导下，独立进行研究工作所取得的成果，不包含涉及国家秘密的内容。尽我所知，除文中已经注明引用的内容外，本学位论文的研究成果不包含任何他人享有著作权的内容。对本论文所涉及的研究工作做出贡献的其他个人和集体，均已在文中以明确方式标明。
    ]
  } else { body } // fallback

  v(back-vspace)

  text(size: use-size(13pt), align(right, back))
}
