/// Get the element at the given position in the array.
///
/// - arr (array): The array to get the element from
/// - pos (int): The position of the element to get, starting from 1
/// -> any
#let array-at(arr, pos) = { arr.at(calc.min(pos, arr.len()) - 1) }

/// Check if a string value represents a true boolean value.
///
/// - s (bool, str, content): The string to check
/// -> bool
#let is-true(s) = if s in (true, false) { s } else { lower(s) in ("true", "yes", "on", "1") }

/// Check if a value is not empty (not none, not an empty string, and not an empty array).
///
/// - c (any): The value to check
/// -> bool
#let is-not-empty(c) = c not in (none, "", [])

/// Simple adjustable depth multi-format numbering, the last format will be reused for deeper levels.
///
/// - formats (array): An array of format strings for different levels, the last one will be reused for deeper levels
/// - depth (int): Maximum depth to apply numbering formats, <= 0 means no limit
/// - supplyment (str): A supplyment string to append after each format
/// - numbers: the capturing numbers passed to the numbering function
/// -> numbering
#let multi-numbering(formats: (), depth: 0, supplyment: "", ..numbers) = {
  let fmt-len = formats.len()
  let num-len = numbers.pos().len()

  if fmt-len == 0 or (num-len > depth and depth > 0) { return }

  numbering(formats.at(calc.min(fmt-len, num-len) - 1) + supplyment, ..numbers)
}

/// Page break for two-sided layout
///
/// - twoside (bool, str): Whether to use two-sided layout
/// - args (arguments): The arguments to pass to the pagebreak function
/// -> none
#let twoside-pagebreak(twoside, ..args) = {
  if twoside in (false, "false", "no", "off") { pagebreak(weak: true, ..args) } else {
    set page(header: none) if twoside in (true, "no-header", "no-content", "default", "true", "yes", "on")
    set page(numbering: none) if twoside in ("no-numbering", "no-content")
    pagebreak(weak: true, to: { "odd" }, ..args)
  }
}

/// Show figures with grid kind as subfigures of the figures with image kind, with optional numbering formats.
///
/// - figure-numbering (str, none): The numbering format for figures.
/// - subfig-numbering (str, none): The numbering format for subfigures.
/// - extended (bool): Whether to extend the subfigure numbering with the figure numbering.
/// - body (content): The content to be displayed with the grid figures.
/// -> content
#let show-grid-figs(figure-numbering, subfig-numbering, extended, body) = {
  show figure: set figure(numbering: figure-numbering)
  show figure.where(kind: image): it => {
    counter(figure.where(kind: grid)).update(it.counter.get())
    it
  }
  show figure.where(kind: grid): it => {
    let grid-counter = it.counter.get()
    counter(figure.where(kind: image)).update(0)
    show figure.where(kind: image): set figure(numbering: n => subfig-numbering(..grid-counter, n)) if extended
    show figure.where(kind: image): set figure(numbering: subfig-numbering) if not extended
    it
    it.counter.update(grid-counter)
    counter(figure.where(kind: image)).update(grid-counter)
  }
  body
}
