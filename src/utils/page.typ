//! Page layout utilities

/// Make page layout functions available for content and options
///
/// - twoside (bool | str): Whether to use two-sided layout
#let _use-twoside(twoside) = {
  if twoside {
    set page(header: none)
    pagebreak(weak: true, to: { "odd" })
  } else if twoside == "no-numbering" {
    set page(header: none, numbering: none)
    pagebreak(weak: true, to: { "odd" })
  } else {
    pagebreak(weak: true)
  }
}
