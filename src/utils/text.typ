/// Make text processing functions available for content.
///
/// - fn (function): the function to apply to the text
/// - body (content | str): the text content to process
/// - args (any): additional arguments to pass to the function
/// -> any
#let _use-content(fn, body, ..args) = if type(body) == content { fn(body.text, ..args) } else {
  assert(type(body) == str, message: "Expected content or string, got " + str(type(body)))
  fn(body, ..args)
}


/// Replace all characters in a string with a mask character.
///
/// - text (str): the text to be masked
/// - mask (str): the character to use as a mask
/// -> str
#let _mask-text(text, mask: "█") = mask * text.clusters().len()

/// Replace all characters in a string with a mask character.
///
/// - body (content | str): the text to be masked
/// - mask (str): the character to use as a mask
/// -> str
#let mask-text(body, ..args) = _use-content(_mask-text, body, ..args)

/// Space out characters in a string with a specified spacing.
///
/// - text (str): the text to space out
/// - space (str): the space to use between characters
/// -> str
#let _space-text(text, space: " ") = text.split("").join(space).trim()

/// Space out characters in a string with a specified spacing.
///
/// - body (content | str): the text to space out
/// - space (str): the space to use between characters
/// -> str
#let space-text(body, ..args) = _use-content(_space-text, body, ..args)

/// Create a text block with distributed text.
///
/// - text (str): the text to distribute
/// - width (length): the width of the block, defaults to auto
/// -> content
#let _distr-text(text, width) = block(width: width, stack(dir: ltr, ..text.clusters().intersperse(1fr)))

/// Create a text block with distributed text.
///
/// - body (content | str): the text to distribute
/// - width (length): the width of the block, defaults to auto
/// -> content
#let distr-text(body, ..args) = _use-content(_distr-text, body, ..args)

/// Create a vertical stack of text clusters.
///
/// - text (str): the text to stack
/// - spacing (length): the spacing between lines
/// -> content
#let _v-text(text, spacing: 3.6pt) = stack(dir: ttb, ..text.clusters(), spacing: spacing)

/// Create a vertical stack of text clusters.
///
/// - body (content | str): the text to stack
/// - spacing (length): the spacing between lines
/// -> content
#let v-text(body, ..args) = _use-content(_v-text, body, ..args)

/// Create a text block with fixed-width text by adjusting tracking,
/// only supports single-line text and width relative to font size.
/// - text (str): the text to adjust
/// - width (length): the target width
/// -> content
#let _fixed-text(str, width) = text(tracking: (width - str.clusters().len() * 1em) / (str.clusters().len() - 1), str)

#let fixed-text(body, ..args) = _use-content(_fixed-text, body, ..args)
