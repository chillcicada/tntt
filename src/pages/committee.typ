#let committee(
  // from entry
  anonymous: false,
  twoside: false,
  doctype: "master",
  // options
) = {
  /// Precheck
  if anonymous { return }

  if doctype not in ("master",) { return }

  /// Render cover page
  pagebreak(weak: true, to: if twoside { "odd" })
}
