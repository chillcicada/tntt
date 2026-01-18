// Apply LaTeX/i-figured style prefix rewrite for refs.
#let apply-latex-ref-to-figure(it, extra-prefixes: (:), fallback: "fig:") = {
  if it.has("label") {
    let prefixes = (table: "tbl:", raw: "lst:") + extra-prefixes

    label(
      prefixes.at(if type(it.kind) == str { it.kind } else { repr(it.kind) }, default: fallback) + str(it.label),
    )
  } else {}
}
