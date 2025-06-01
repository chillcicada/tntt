#import "../utils/font.typ": use-size

/// Copyright Page
///
/// - anonymous (): whether to hide the signature
/// - twoside (): whether to use two-sided printing
/// - fonts (): fonts scheme
/// - title (): the title of the page
/// - title-size (): the size of the title
/// - body (): body content
/// - back (): back content
/// -> copyright
#let copyright(
  // from entry
  anonymous: false,
  twoside: false,
  fonts: (:),
  // options
  title: [关于论文使用授权的说明],
  title-size: "二号",
  body: [
    本人完全了解清华大学有关保留、使用综合论文训练论文的规定，即：学校有权保留论文的复印件，允许论文被查阅和借阅；学校可以公布论文的全部或部分内容，可以采用影印、缩印或其他复制手段保存论文。
  ],
  back: [
    签　　名：

    导师签名：

    日　　期：
  ],
) = {
  if anonymous { return }

  pagebreak(weak: true, to: if twoside { "odd" })

  align(
    center,
    text(
      font: fonts.HeiTi,
      size: use-size(title-size),
      title,
    ),
  )

  v(1em)

  body

  v(2em)

  grid(
    columns: (1fr, 150pt),
    [], align(left, back),
  )
}
