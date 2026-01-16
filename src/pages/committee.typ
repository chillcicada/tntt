#let committee(
  // from entry
  anonymous: false,
  twoside: false,
  doctype: "master",
  // options
  title: [学位论文指导小组、公开评阅人和答辩委员会名单],
) = {
  if anonymous or doctype not in ("master", "doctor", "postdoc") { return }

  import "../utils/page.typ": use-twoside

  use-twoside(twoside)
}
