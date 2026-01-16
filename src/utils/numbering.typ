/// Simple adjustable depth multi-format numbering, the last format will be reused for deeper levels
///
/// - formats (array): An array of format strings for different levels, the last one will be reused for deeper levels
/// - depth (int): Maximum depth to apply numbering formats, <= 0 means no limit
/// - supplyment (str): A supplyment string to append after each format
/// - ..numbers: the capturing numbers passed to the numbering function
/// -> numbering
#let multi-numbering(formats: (), depth: 0, supplyment: "", ..numbers) = {
  let f-len = formats.len()
  let n-len = numbers.pos().len()

  if f-len == 0 or (n-len > depth and depth > 0) { return }

  numbering(formats.at(calc.min(f-len, n-len) - 1) + supplyment, ..numbers)
}
