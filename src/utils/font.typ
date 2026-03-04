//! Built-in font family for CJK
//!
//! Currently, there are already many related packages available to implement similar functions.
//! So you should explore and use them instead of relying on this built-in implementation
//! since the current implementation is not perfect. All except `use-size` is not exported.

#let _builtin-font-family = ("SongTi", "HeiTi", "KaiTi", "FangSong", "Mono", "Math")

#let _builtin-get-en-font(fonts) = fonts.at(0)
#let _builtin-get-cjk-fonts(fonts) = fonts.slice(1)

#let _unwrap-font(font) = type(font) == if type(font) == str { font } else { font.name }
#let _use-fonts(fonts, name) = {
  for key in fonts.keys() {
    assert(key in _support-font-family, message: "Supported font family: " + _builtin-font-family.join(", "))
  }
  assert(_builtin-font-family.contains(name), message: "Unsupported font family " + name)
  fonts.at(name)
}
#let _use-en-font(fonts, name) = _unwrap-font(_builtin-get-en-font(_use-fonts(fonts, name)))
#let _use-cjk-fonts(fonts, name) = _builtin-get-cjk-fonts(_use-fonts(fonts, name)).map(_unwrap-font)

/// Word compatible font size for CJK
#let _builtin-font-size = (
  初号: 42pt,
  小初: 36pt,
  一号: 26pt,
  小一: 24pt,
  二号: 22pt,
  小二: 18pt,
  三号: 16pt,
  小三: 15pt,
  四号: 14pt,
  中四: 13pt,
  小四: 12pt,
  五号: 10.5pt,
  小五: 9pt,
  六号: 7.5pt,
  小六: 6.5pt,
  七号: 5.5pt,
  小七: 5pt,
)

/// Make cjk font size compatible with normal size
///
/// - size (str | length): the font size to use, available cjk font sizes
/// -> length
#let use-size(size) = {
  if type(size) == str {
    assert(_builtin-font-size.keys().contains(size), message: "Unsupported font size str " + size)
    _builtin-font-size.at(size)
  } else {
    assert(type(size) == length, message: "Invalid font size type.")
    size
  }
}
