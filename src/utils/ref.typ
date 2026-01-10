#let _latex-prefixes = ("fig:", "tbl:", "eq:", "lst:", "alg:", "img:")

// Strip a LaTeX/i-figured style prefix from a label string if present.
#let _strip-legacy-prefix(s) = {
  for p in _latex-prefixes {
    if s.starts-with(p) { return s.slice(p.len()) }
  }
  s
}

// Apply compatibility rewrite for refs.
#let apply-latex-ref-compat(body) = {
  show ref: r => context {
    if r.element != none { return r }

    let t = str(r.target)
    let stripped = _strip-legacy-prefix(t)

    if stripped == t { return r }
    let new = ref(label(stripped), supplement: r.supplement)
    new
  }
  body
}
