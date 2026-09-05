// Optional packages remain separate from the starter template. Copy only the
// imports and examples that a thesis actually uses.
#import "@preview/theorion:0.6.0": *
#import cosmos.simple: *
#import "@preview/lovelace:0.3.1": pseudocode-list
#import "@preview/cetz:0.5.2"

#set page(paper: "a4", margin: 2.5cm)
#set text(size: 11pt)
#show: show-theorion

= Theorem environments

#theorem[Central limit theorem][
  For independent and identically distributed random variables with finite
  variance, the normalized sample mean converges in distribution to a normal
  random variable.
] <thm:clt>

#proof[
  Apply the characteristic-function form of the classical central limit theorem.
]

= Pseudocode

#figure(
  pseudocode-list[
    + initialize the estimate
    + *while* the stopping criterion is false
      + update the estimate
    + *return* the estimate
  ],
  kind: "algorithm",
  supplement: [Algorithm],
  caption: [Iterative estimation],
) <alg:estimate>

= Programmatic figures

#figure(
  cetz.canvas({
    import cetz.draw: *
    circle((0, 0), radius: 0.35, fill: luma(235))
    content((0, 0), [data])
    line((0.35, 0), (2.15, 0), mark: (end: ">"))
    circle((2.5, 0), radius: 0.35, fill: luma(235))
    content((2.5, 0), [result])
  }),
  caption: [A minimal analysis pipeline],
) <fig:pipeline>

The optional components participate in normal references: @thm:clt,
@alg:estimate, and @fig:pipeline.
