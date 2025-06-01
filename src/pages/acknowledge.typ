/// Acknowledgement Page
#let acknowledge(
  // from entry
  anonymous: false,
  twoside: false,
  // options
  title: [致　谢],
  outlined: true,
  // self
  it,
) = {
  if anonymous { return }

  pagebreak(weak: true, to: if twoside { "odd" })

  [#heading(level: 1, numbering: none, outlined: outlined, title) <no-auto-pagebreak>]

  it
}
