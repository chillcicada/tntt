/// Committee Page
///
/// - anonymous (bool): Whether to use anonymous mode.
/// - twoside (bool | str): Whether to use two-sided layout.
/// - doctype ("master" | "doctor" | "postdoc" | str): The document type.
/// - fonts (dictorary): The dictionary of fonts to use.
/// - title (content | str): The title of the committee page.
/// - outlined (bool): Whether to outline the page.
/// - bookmarked (bool): Whether to add a bookmark for the page.
/// - supervisors (array): The list of supervisors.
/// - supervisors-title (content | str): The title for the supervisors section.
/// - supervisors-columns (array): The widths of the grid columns for supervisors.
/// - reviewers (array): The list of reviewers.
/// - reviewers-title (content | str): The title for the reviewers section.
/// - reviewers-columns (array): The widths of the grid columns for reviewers.
/// - defenders (dictionary): The dictionary of defenders, where keys are roles and values are lists of names.
/// - defenders-title (content | str): The title for the defenders section.
/// - defenders-columns (array): The widths of the grid columns for defenders.
/// -> content
#let committee(
  // from entry
  anonymous: false,
  twoside: false,
  doctype: "master",
  fonts: (:),
  // options
  title: [学位论文指导小组、公开评阅人和答辩委员会名单],
  outlined: false,
  bookmarked: true,
  supervisors: (),
  supervisors-title: [指导小组名单],
  supervisors-columns: (3cm, 3cm, 9cm),
  reviewers: (),
  reviewers-title: [公开评阅人名单],
  reviewers-columns: (3cm, 3cm, 9cm),
  defenders: (:),
  defenders-title: [答辩委员会名单],
  defenders-columns: (2.75cm, 2.98cm, 4.63cm, 4.63cm),
) = {
  if anonymous or doctype not in ("master", "doctor", "postdoc") { return }

  import "../utils/page.typ": use-twoside
  import "../utils/font.typ": _use-fonts, use-size

  let use-fonts = name => _use-fonts(fonts, name)
  let format-text = str => {
    v(20pt)
    text(size: use-size("小三"), font: use-fonts("HeiTi"), str)
    v(2pt)
  }

  /// Rendering
  use-twoside(twoside)

  set align(center)
  set par(justify: false) // disable full justify
  set grid(row-gutter: 1em, align: horizon)

  heading(level: 1, numbering: none, outlined: outlined, bookmarked: bookmarked, title)

  v(2pt)

  format-text(supervisors-title)
  grid(columns: supervisors-columns, ..supervisors.flatten())

  format-text(reviewers-title)
  grid(columns: reviewers-columns, ..reviewers.flatten())

  format-text(defenders-title)
  grid(columns: defenders-columns, ..defenders.keys().map(k => (k, defenders.at(k).intersperse(""))).flatten())
}
