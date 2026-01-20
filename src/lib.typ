#import "imports.typ": *
#import "utils/font.typ": use-size
#import "utils/numbering.typ": multi-numbering
#import "utils/text.typ": distr-text, mask-text, space-text, v-text

/// Define the configuration for the document.
///
/// - degree ("bachelor"): The degree.
/// - degree-type ("academic"): The degree-type type.
/// - anonymous (bool): Whether to use anonymous mode.
/// - twoside (bool | str): Whether to use two-sided printing.
/// - strict (bool): Whether to enable strict check mode for text rendering.
/// - bibliography (): The bibliography entry.
/// - fonts (dictionary): The font family to use.
/// - info (dictionary): The information to be displayed in the document.
/// -> dictionary
#let define-config(
  degree: "bachelor",
  degree-type: "academic",
  anonymous: false,
  twoside: false,
  bibliography: none,
  fonts: (:),
  info: (:),
) = {
  /// ------ ///
  /// Layout ///
  /// ------ ///

  import "layouts/doc.typ": doc, meta
  import "layouts/front-matter.typ": front-matter
  import "layouts/main-matter.typ": main-matter
  import "layouts/back-matter.typ": back-matter

  /// ----- ///
  /// Pages ///
  /// ----- ///

  // before content
  import "pages/fonts-display.typ": fonts-display
  import "pages/cover.typ": cover, cover-en
  import "pages/committee.typ": committee
  import "pages/copyright.typ": copyright

  // front matter
  import "pages/abstract.typ": abstract, abstract-en
  import "pages/outline-wrapper.typ": outline-wrapper
  import "pages/list-of.typ": equation-list, figure-list, figure-table-list, master-list, table-list
  import "pages/notation.typ": notation

  // main matter
  // (no specific pages)

  // back matter
  import "pages/bilingual-bibliography.typ": bilingual-bibliography
  // (appendices, no specific pages)
  import "pages/acknowledge.typ": acknowledge
  import "pages/declaration.typ": declaration
  import "pages/achievement.typ": achievement
  import "pages/review-material.typ": comments, record-sheet, resolution

  /// --------- ///
  /// Auxiliary ///
  /// --------- ///

  import "utils/font.typ": _use-cjk-fonts, _use-fonts, fonts-check
  import "utils/page.typ": use-twoside
  import "utils/util.typ": extend, str2bool

  /// ------- ///
  /// Process ///
  /// ------- ///

  if type(twoside) == str { twoside = str2bool(twoside) }
  if type(anonymous) == str { anonymous = str2bool(anonymous) }

  let _support-degree = ("bachelor", "master", "doctor", "postdoc")
  assert(_support-degree.contains(degree), message: "不支持的文档类型, 目前支持的有: " + _support-degree.join(", "))

  // "academic" "professional"
  let _support-degree-type = ("academic",)
  assert(
    _support-degree-type.contains(degree-type),
    message: "不支持的学位类型, 目前支持的有: " + _support-degree-type.join(", "),
  )

  let extend-info(kwargs) = extend(info, "info", kwargs)
  let extend-fonts(kwargs) = fonts-check(extend(fonts, "fonts", kwargs))

  // @typstyle off
  return (
    /// ------- ///
    /// options ///
    /// ------- ///
    info: info,
    fonts: fonts,
    degree-type: degree-type,
    degree: degree,
    twoside: twoside,
    anonymous: anonymous,
    use-twoside: use-twoside(twoside),
    use-fonts: name => _use-fonts(fonts, name),
    use-cjk-fonts: name => _use-cjk-fonts(fonts, name),
    /// ------- ///
    /// layouts ///
    /// ------- ///
    // 文档元配置 | Document Meta Configuration
    meta: (..args) => meta(info: info, ..args), // info of meta cannot be overwritten
    // 文稿设置 | Document Layout Configuration
    doc: (..args) => doc(..args, fonts: extend-fonts(args)),
    // 前辅文设置 | Front Matter Layout Configuration
    front-matter: (..args) => front-matter(degree: degree, ..args),
    // 正文设置 | Main Matter Layout Configuration
    main-matter: (..args) => main-matter(twoside: twoside, equation-numbering: "(1-1)", ..args),
    // 后辅文设置 | Back Matter Layout Configuration
    back-matter: (..args) => back-matter(twoside: twoside, ..args),
    /// ----- ///
    /// pages ///
    /// ----- ///
    // 字体展示页 | Fonts Display Page
    fonts-display: (..args) => fonts-display(..args, fonts: extend-fonts(args)),
    // 中文封面页 | Cover Page
    cover: (..args) => cover(degree: degree, anonymous: anonymous, ..args, fonts: extend-fonts(args), info: extend-info(args)),
    // 英文封面页 | Cover (English) Page
    cover-en: (..args) => cover-en(degree: degree, anonymous: anonymous, ..args, fonts: extend-fonts(args), info: extend-info(args)),
    // 学位论文指导小组、公开评阅人和答辩委员会名单页 | Thesis Committee Page
    committee: (..args) => committee(degree: degree, anonymous: anonymous, twoside: twoside, ..args, fonts: extend-fonts(args)),
    // 授权页 | Copyright Page
    copyright: (..args) => copyright(degree: degree, anonymous: anonymous, twoside: twoside, ..args),
    // 中文摘要页 | Abstract Page
    abstract: (..args) => abstract(twoside: twoside, ..args, fonts: extend-fonts(args)),
    // 英文摘要页 | Abstract (English) Page
    abstract-en: (..args) => abstract-en(twoside: twoside, ..args, fonts: extend-fonts(args)),
    // 目录页 | Outline Page
    outline-wrapper: (..args) => outline-wrapper(twoside: twoside, ..args, fonts: extend-fonts(args)),
    // 总清单页 | Master List Page
    master-list: (..args) => master-list(twoside: twoside, ..args),
    // 插图和附表清单页 | Figure and Table Index Page
    figure-table-list: (..args) => figure-table-list(twoside: twoside, ..args),
    // 插图清单页 | Figure List Page
    figure-list: (..args) => figure-list(twoside: twoside, ..args),
    // 附表清单页 | Table List Page
    table-list: (..args) => table-list(twoside: twoside, ..args),
    // 公式清单页 | Equation List Page
    equation-list: (..args) => equation-list(twoside: twoside, ..args),
    // 符号表页 | Notation Page
    notation: (..args) => notation(twoside: twoside, ..args),
    // 参考文献页 | Bibliography Page
    bilingual-bibliography: (..args) => bilingual-bibliography(bibliography: bibliography, ..args),
    // 致谢页 | Acknowledge Page
    acknowledge: (..args) => acknowledge(anonymous: anonymous, twoside: twoside, ..args),
    // 声明页 | Declaration Page
    declaration: (..args) => declaration(degree: degree, anonymous: anonymous, twoside: twoside, ..args),
    // 个人简历、在学期间完成的相关学术成果说明页 | Resume & Achievement Page
    achievement: (..args) => achievement(degree: degree, anonymous: anonymous, twoside: twoside, ..args, fonts: extend-fonts(args)),
    // 论文训练记录表 | Record Sheet Page
    record-sheet: (..args) => record-sheet(degree: degree, anonymous: anonymous, twoside: twoside, ..args, info: extend-info(args)),
    // 指导教师/指导小组评语页 | Advisor Comments Page
    comments: (..args) => comments(degree: degree, anonymous: anonymous, twoside: twoside, ..args),
    // 答辩委员会决议书 | Committee Resolution Page
    resolution: (..args) => resolution(degree: degree, anonymous: anonymous, twoside: twoside, ..args),
  )
}
