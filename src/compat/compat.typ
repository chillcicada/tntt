#import "legacy-refs.typ": legacy-ref-compat

#let compat(body) = {
  show: legacy-ref-compat
  body
}
