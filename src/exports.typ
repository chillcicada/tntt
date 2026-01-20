/// ------ ///
/// Layout ///
/// ------ ///

#import "layouts/doc.typ": doc, meta
#import "layouts/front-matter.typ": front-matter
#import "layouts/main-matter.typ": main-matter
#import "layouts/back-matter.typ": back-matter

/// ----- ///
/// Pages ///
/// ----- ///

// before content
#import "pages/fonts-display.typ": fonts-display
#import "pages/cover.typ": cover, cover-en
#import "pages/committee.typ": committee
#import "pages/copyright.typ": copyright

// front matter
#import "pages/abstract.typ": abstract, abstract-en
#import "pages/outline-wrapper.typ": outline-wrapper
#import "pages/list-of.typ": equation-list, figure-list, figure-table-list, master-list, table-list
#import "pages/notation.typ": notation

// main matter
// (no specific pages)

// back matter
#import "pages/bilingual-bibliography.typ": bilingual-bibliography
// (appendices, no specific pages)
#import "pages/acknowledge.typ": acknowledge
#import "pages/declaration.typ": declaration
#import "pages/achievement.typ": achievement
#import "pages/review-material.typ": comments, record-sheet, resolution

/// --------- ///
/// Auxiliary ///
/// --------- ///

#import "utils/font.typ": _use-cjk-fonts, _use-fonts, fonts-check
#import "utils/page.typ": use-twoside
#import "utils/util.typ": extend, str2bool

/// ------- ///
/// Process ///
/// ------- ///
