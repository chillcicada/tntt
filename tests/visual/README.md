# Visual fixtures

`main.tex` and `main-en.tex` mirror the complete document in
`contrib/latex-parity/main.typ`. The workflow compiles them against the pinned
ThuThesis revision to review whole-document layout.

`cases.tex` and `cases.typ` are focused fixtures for local investigation. Both
accept the same degree, language, and output settings and contain matching body,
figure, table, equation, and appendix content. They use the workflow's existing
configuration mapping. The workflow places the complete and focused comparisons
under separate directories in the same case bundle.

Each comparison directory contains the original LaTeX and Typst PDFs, a
three-column review PDF, a full-size overlay, a JSON report, and a short README.
The case directory also retains LaTeX, BibTeX, and Typst logs. Page-count
differences remain visible as blank panels and are recorded in the JSON report.

The configuration mapping is explicit:

| Workflow value | ThuThesis | TnTT |
| --- | --- | --- |
| `chinese` | `language=chinese` | `lang=zh` |
| `english` | `language=english` | `lang=en` |
| `electronic` | `output=electronic` | `twoside=false` |
| `print` | `output=print` | `twoside=true` |
