#import "util.typ": use-content

/// Replace all characters in a string with a mask character.
///
/// - text (): the text to be masked
/// - mask (): the character to use as a mask
/// -> string
#let _mask-text(text, mask: "█") = mask * text.clusters().len()

#let mask-text(body, ..args) = use-content(_mask-text, body, ..args)

/// Space out characters in a string with a specified spacing.
///
/// - text (): the text to space out
/// - spacing (): the spacing to use between characters
/// -> string
#let _space-text(text, spacing: " ") = text.split("").join(spacing).trim()

#let space-text(body, ..args) = use-content(_space-text, body, ..args)

/// Create a text block with distributed text.
///
/// - text (): the text to distribute
/// - width (): the width of the block, defaults to auto
/// -> block
#let _distr-text(text, width: auto) = {
  block(
    width: width,
    stack(dir: ltr, ..text.clusters().map(x => [#x]).intersperse(1fr)),
  )
}

#let distr-text(body, ..args) = use-content(_distr-text, body, ..args)
