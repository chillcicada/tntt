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
/// - page-opts (dict): Additional options for the page layout when twoside is enabled
/// - pagebreak-opts (dict): Additional options for the page break
/// -> none
#let twoside-pagebreak(twoside, page-opts: (:), pagebreak-opts: (weak: true)) = {
  if twoside in (false, "false", "no", "off") { pagebreak(..pagebreak-opts) } else {
    page-opts += if twoside in (true, "no-header", "no-content", "default", "true", "yes", "on") { (header: none) }
    page-opts += if twoside in ("no-numbering", "no-content") { (numbering: none) }
    pagebreak-opts += (to: { "odd" })

    set page(..page-opts)
    pagebreak(..pagebreak-opts)
  }
}
