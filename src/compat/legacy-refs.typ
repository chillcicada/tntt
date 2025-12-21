#let _legacy-prefixes = ("fig:", "tbl:", "eqt:", "lst:", "alg:", "img:")

// Strip a legacy prefix from a label string if present.
#let _strip-legacy-prefix(s) = {
  for p in _legacy-prefixes {
    if s.starts-with(p) { return s.slice(p.len()) }
  }
  s
}

// Install compatibility rewrite for refs.
#let legacy-ref-compat(body) = {
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
