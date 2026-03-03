/// Get the element at the given position in the array, return the last element if the position is out of bounds
///
/// - arr (array): The array to get the element from
/// - pos (int): The position of the element to get, starting from 1
/// -> any
#let array-at(arr, pos) = { arr.at(calc.min(pos, arr.len()) - 1) }

/// Convert a string to a boolean value, recognizing common true/false representations (case-insensitive)
///
/// - s (str | content): the string to convert to bool
/// -> bool
#let str2bool(s) = {
  s = lower(s)
  if (s == "true" or s == "1" or s == "yes" or s == "on") {
    true
  } else if (s == "false" or s == "0" or s == "no" or s == "off") {
    false
  } else {
    panic("Cannot convert string to bool: " + s)
  }
}

/// Extend a dictionary with additional key-value pairs from kwargs
///
/// - val (dict): The original dictionary to extend
/// - key (str): The key to look for in kwargs
/// - kwargs: The keyword arguments containing the additional key-value pairs
/// -> dict
#let extend-dict(val, key, kwargs) = { val + kwargs.named().at(key, default: (:)) }

/// Check if a value is not empty (not none, not an empty string, and not an empty array)
///
/// - c (any): The value to check
/// -> bool
#let is-not-empty(c) = c not in (none, "", [])

/// Simple adjustable depth multi-format numbering, the last format will be reused for deeper levels
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

/// Make page layout functions available for content and options
///
/// - twoside (bool | str): Whether to use two-sided layout
#let use-twoside(twoside) = {
  if twoside {
    set page(header: none)
    pagebreak(weak: true, to: { "odd" })
  } else if twoside == "no-numbering" {
    set page(header: none, numbering: none)
    pagebreak(weak: true, to: { "odd" })
  } else {
    pagebreak(weak: true)
  }
}

