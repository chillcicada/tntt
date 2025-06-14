#let array-at(arr, pos) = { arr.at(calc.min(pos, arr.len()) - 1) }

#let use-content(fn, body, ..args) = {
  if type(body) == content { fn(body.text, ..args) } else {
    assert(type(body) == str, message: "Expected content or string, got " + str(type(body)))
    fn(body, ..args)
  }
}
