#let committee-content = [
  #heading(level: 2, numbering: none, outlined: false)[指导小组名单]

  #align(center, table(
    columns: (3cm, 3cm, 1fr),
    align: center,
    stroke: none,
    [李XX], [教授], [清华大学],
    [王XX], [副教授], [清华大学],
    [张XX], [助理教授], [清华大学],
  ))

  #heading(level: 2, numbering: none, outlined: false)[公开评阅人名单]

  #align(center, table(
    columns: (3cm, 3cm, 1fr),
    align: center,
    stroke: none,
    [刘XX], [教授], [清华大学],
    [陈XX], [副教授], [XXXX大学],
    [杨XX], [研究员], [中国XXXX科学院XXXXXXX研究所],
  ))

  #heading(level: 2, numbering: none, outlined: false)[答辩委员会名单]

  #align(center, table(
    columns: (2.75cm, 2.98cm, 4.63cm, 4.63cm),
    align: center,
    stroke: none,
    [主席], [赵XX], [教授], [清华大学],
    [委员], [刘XX], [教授], [清华大学],
    [],
    table.cell(rowspan: 2, align: center + horizon)[杨XX],
    table.cell(rowspan: 2, align: center + horizon)[研究员],
    [中国XXXX科学院],
    [], [XXXXXXX研究所],
    [], [黄XX], [教授], [XXXX大学],
    [], [周XX], [副教授], [XXXX大学],
    [秘书], [吴XX], [助理研究员], [清华大学],
  ))
]

// 也可以导入由 Word 转换得到的 PDF：
// #(thesis.committee)(file: read("fig/committee.pdf", encoding: none))[]
