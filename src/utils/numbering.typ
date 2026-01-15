/// Adjustable depth multi-format numbering, the last format will be reused for deeper levels
///
/// - formats (array): An array of format strings for different levels
/// - depth (int): Maximum depth to apply numbering formats
/// - ..args: Additional arguments passed from the capturing numbering
/// -> numbering
#let multi-numbering(formats, depth, ..args) = {
  let len = formats.len()
  let pos = args.pos().len()

  if len == 0 or (pos > depth and depth > 0) { return }

  // (pos - 1).saturating_sub(len - 1)
  numbering(formats.at(calc.min(pos, len) - 1), ..(args.pos().slice(if pos < len { pos - 1 } else { pos - len })))
}
