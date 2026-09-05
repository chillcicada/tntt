# Extended examples

`latex-parity/main.typ` is the complete Chinese and English reference document.
It demonstrates every major page and keeps the long instructional chapters out
of projects created from the package template. Compile it with:

```sh
typst compile --root . --font-path fonts --input lang=zh contrib/latex-parity/main.typ
typst compile --root . --font-path fonts --input lang=en contrib/latex-parity/main.typ
```

When editing a document split across several files, open `main.typ` and run
`Typst Pin Main` in Tinymist. This lets diagnostics, labels, citations, and
completion in included files use the complete document context.

`writing-packages.typ` is a standalone, compilable introduction to three
optional packages that are useful in theses: [Theorion] for theorem environments,
[Lovelace] for pseudocode, and [CeTZ] for programmatic figures. Their imports remain
outside the starter template, so new projects add only the dependencies they use.

## 扩展示例

`latex-parity/main.typ` 是完整的中英文参考文档. 它展示主要页面和较长的写作示例,
通过 `lang` 输入切换语言. 软件包生成的新项目只包含精简入口.

编辑拆分为多个文件的文档时, 请先打开 `main.typ`, 再在 Tinymist 中运行
`Typst Pin Main` 命令. 此操作为子文件提供完整的诊断, 标签, 引用和补全上下文.

`writing-packages.typ` 是独立且可编译的扩展示例. 它展示用于定理环境的 Theorion,
用于伪代码的 Lovelace 和用于程序化绘图的 CeTZ. 起步模板不导入这些可选依赖.

[Theorion]: https://typst.app/universe/package/theorion/
[Lovelace]: https://typst.app/universe/package/lovelace/
[CeTZ]: https://typst.app/universe/package/cetz/
