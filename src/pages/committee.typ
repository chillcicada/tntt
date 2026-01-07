#let committee(
  // from entry
  anonymous: false,
  twoside: false,
  doctype: "master",
  // options
  title: [学位论文指导小组、公开评阅人和答辩委员会名单],
) = {
  /// Precheck
  if anonymous { return }

  if doctype not in ("master",) { return }

  /// Render cover page
  pagebreak(weak: true, to: if twoside { "odd" })
}
