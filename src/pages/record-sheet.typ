#let record-sheet(
  // from entry
  anonymous: false,
  twoside: false,
  info: (:),
  // options
  title: [综合论文训练记录表],
  prefill: false,
  // self
  it,
) = {
  if anonymous { return }

  pagebreak(weak: true, to: if twoside { "odd" })

  heading(level: 1, numbering: none, outlined: false, bookmarked: false, title)
}
