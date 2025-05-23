/// Replace all characters in a string with a mask character.
///
/// - text (): the text to be masked
/// - mask (): the character to use as a mask
/// -> string
#let mask(text, mask: "█") = mask * text.clusters().len()
