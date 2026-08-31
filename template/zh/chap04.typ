= 引用文献的标注

Typst 原生读取 BibLaTeX 数据库，并通过 CSL 样式生成引用和参考文献。
`bibliography-thu` 将这一能力统一包装。

== 顺序编码制

顺序编码制是研究生论文的默认样式，文献序号默认以上标显示。普通引用、作者作为正文、带页码引用和多文献引用可分别写成：

#table(
  columns: (1fr, 1fr),
  align: left,
  stroke: none,
  [`@zhangkun1994`], [@zhangkun1994],
  [`张昆等@zhangkun1994`], [张昆等@zhangkun1994],
  [`#cite(<zhangkun1994>)42`], [#cite(<zhangkun1994>)42],
  [`@zhangkun1994 @zhukezhen1973`], [@zhangkun1994 @zhukezhen1973],
)

当前 GB/T CSL
的叙述式引用会列出完整作者，因此需要“张昆等”这样的简称时，应直接写出作者并在后面引用。该
CSL 也不显示 `@key[页码]`
中的补充信息，所以页码应紧跟在引用之后。多篇文献之间只留空格，Typst
才会把它们合并为一组；两个连续编号显示为逗号分隔，三个及以上连续编号会压缩为区间。

== 著者-出版年制

著者—出版年制由文档配置中的 `bibliography-style: "author-year"`
统一启用，无需改变正文中的引用标签。 叙述式引用可使用
`form: "prose"`，括号式引用使用普通引用形式。

本示例采用顺序编码制，因此这里仍按同一数据库展示引用 @zhangkun1994 和
@zhukezhen1973；将根文件的参考文献样式切换为 `author-year`
后，正文和文后列表会一起变为著者—出版年格式。

每条列入参考文献表的文献通常都应在正文中标注。为了完整展示仓库自带数据库，本示例在
`bibliography-thu` 中使用
`full: true`；正式论文一般保留默认值，只输出实际引用的条目。
