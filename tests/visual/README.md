# Visual fixtures

`main.tex` and `main-en.tex` mirror the complete document in
`contrib/latex-parity/main.typ`. The workflow compiles them against the pinned
ThuThesis revision to review whole-document layout.

`cases.tex` and `cases.typ` are focused fixtures for local investigation. Both
accept the same degree, language, and output settings and contain matching body,
figure, table, equation, and appendix content. They use the workflow's existing
configuration mapping and can be compared independently of the long example.

The configuration mapping is explicit:

| Workflow value | ThuThesis | TnTT |
| --- | --- | --- |
| `chinese` | `language=chinese` | `lang=zh` |
| `english` | `language=english` | `lang=en` |
| `electronic` | `output=electronic` | `twoside=false` |
| `print` | `output=print` | `twoside=true` |
