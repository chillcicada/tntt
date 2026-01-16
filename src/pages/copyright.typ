/// Copyright Page
///
/// - anonymous (bool): Whether to use anonymous mode.
/// - twoside (bool | str): Whether to use two-sided layout.
/// - doctype ("bachelor"): The document type.
/// - title (content): The title of the copyright page.
/// - title-size (length | str): The size of the title font.
/// - outlined (bool): Whether to outline the page.
/// - bookmarked (bool): Whether to add a bookmark for the page.
/// - body (content): The body content of the copyright page.
/// - grid-columns (array): The widths of the grid columns for signatures.
/// - back (array): The back text for signatures, should be an array of strings.
/// -> content
#let copyright(
  // from entry
  anonymous: false,
  twoside: false,
  doctype: "bachelor",
  // options
  title: [关于论文使用授权的说明],
  title-size: "二号",
  outlined: false,
  bookmarked: false,
  body: [],
  grid-columns: (2.99cm, 3.29cm, 2.96cm, 3.66cm),
  back: ("作者签名： ", "导师签名：", "日　　期： ", "日　　期："),
) = {
  if anonymous { return }

  import "../utils/font.typ": use-size
  import "../utils/util.typ": is-not-empty
  import "../utils/page.typ": use-twoside

  use-twoside(twoside)

  // TODO: we need a less invasive method
  heading(level: 1, numbering: none, outlined: outlined, bookmarked: bookmarked, {
    v(0.91em)
    text(size: use-size(title-size), title)
    v(1.42em)
  })

  {
    set text(size: use-size("四号"))
    set par(leading: 16.4pt, spacing: 16.4pt)

    if is-not-empty(body) { body } else if doctype == "bachelor" {
      [
        本人完全了解清华大学有关保留、使用综合论文训练论文的规定，即：学校有权保留论文的复印件，允许论文被查阅和借阅；学校可以公布论文的全部或部分内容，可以采用影印、缩印或其他复制手段保存论文。
      ]
    } else if doctype == "master" {
      [
        本人完全了解清华大学有关保留、使用学位论文的规定，即：

        清华大学拥有在著作权法规定范围内学位论文的使用权，其中包括：（1）已获学位的研究生必须按学校规定提交学位论文，学校可以采用影印、缩印或其他复制手段保存研究生上交的学位论文；（2）为教学和科研目的，学校可以将公开的学位论文作为资料在图书馆、资料室等场所供校内师生阅读，或在校园网上供校内师生浏览部分内容；（3）按照上级教育主管部门督导、抽查等要求，报送相应的学位论文。

        本人保证遵守上述规定。
      ]
    } else { body }
  }

  v(5.41em)

  align(center, block(
    width: grid-columns.sum(),
    grid(
      columns: grid-columns,
      column-gutter: (-3pt, -2pt, 2pt),
      row-gutter: 21.2pt,
      align: center,
      ..back.intersperse("")
    ),
  ))
}
