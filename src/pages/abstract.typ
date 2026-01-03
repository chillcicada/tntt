/// Abstract Page (Simplified Chinese version)
///
/// - fonts (dictionary): the font family to use, should be a dictionary.
/// - twoside (bool): two-sided printing.
/// - title (content): the title of the abstract page.
/// - outlined (bool): whether to outline the page.
/// - bookmarked (bool): whether to add a bookmark for the page.
/// - indent-back (bool): whether to indent the back text.
/// - back (content): the back text, default is [*关键词：*].
/// - back-font ("SongTi" | "HeiTi" | "KaiTi" | "FangSong" | "Mono" | "Math"): the font for the back text.
/// - back-vspace (length): the vertical space after the abstract content.
/// - keywords (array): keywords to be included in the abstract.
/// - keyword-sperator (str): the separator for keywords, default is "；".
/// - keyword-font ("SongTi" | "HeiTi" | "KaiTi" | "FangSong" | "Mono" | "Math"): the font for the keywords.
/// - it (content): the main content of the abstract page.
/// -> content
#let abstract(
  // from entry
  fonts: (:),
  twoside: false,
  // options
  title: [摘　要],
  outlined: false,
  bookmarked: true,
  indent-back: false,
  back: [*关键词：*],
  back-font: "HeiTi",
  back-vspace: 20.1pt,
  keywords: (),
  keyword-sperator: "；",
  keyword-font: "SongTi",
  // self
  it,
) = {
  import "../utils/font.typ": _use-fonts

  let use-fonts = name => _use-fonts(fonts, name)

  /// Render the abstract page
  pagebreak(weak: true, to: if twoside { "odd" })

  heading(level: 1, outlined: outlined, bookmarked: bookmarked, title)

  it

  v(back-vspace)

  par(
    first-line-indent: if indent-back { 2em } else { 0em },
    text(font: use-fonts(back-font), back) + text(font: use-fonts(keyword-font), keywords.join(keyword-sperator)),
  )
}

/// Abstract Page (English version), Inherited from the Chinese version
#let abstract-en(..args) = abstract(
  title: [Abstract],
  back: [*Keywords: *],
  back-font: "SongTi",
  keyword-sperator: "; ",
  ..args,
)
