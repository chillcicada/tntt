/// Front Matter Layout
///
/// - doctype ("bachelor" | "master" | "doctor" | "postdoc"): The document type.
/// - page-numbering (str): The numbering format for the page.
/// - header-display (bool | auto): Whether to display the header.
/// - header-stroke (stroke): The stroke style for the header line.
/// - header-ascent (length): The ascent of the header from the top of the page
/// - it (content): The content to be displayed in the front matter.
/// -> content
#let front-matter(
  // from entry
  doctype: "bachelor",
  // options
  page-numbering: "I",
  header-display: auto,
  header-stroke: 1pt + black,
  header-ascent: 10% + 0pt,
  // self
  it,
) = {
  import "../utils/font.typ": use-size
  import "../utils/util.typ": is-not-empty

  if header-display == auto { header-display = doctype != "bachelor" }

  // Reset the counter of pages
  counter(page).update(1)

  set page(numbering: page-numbering, header-ascent: header-ascent, header: if header-display {
    context {
      let head = query(selector(heading.where(level: 1)).after(here()))
        .filter(it => it.location().page() == here().page())
        .first(default: query(selector(heading.where(level: 1)).before(here())).last(default: none))

      if head == none { return }

      align(center, text(size: use-size("五号"), {
        if head.numbering != none { numbering(head.numbering, ..counter(heading).at(head.location())) }
        head.body
      }))
    }

    v(-0.6em)

    line(length: 100%, stroke: header-stroke)
  })

  it
}
