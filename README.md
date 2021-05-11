# (WIP) Enumr <img src='man/figures/logo.png' align="right" height="120" />

<!-- badges: start -->
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental) [![R-CMD-check](https://github.com/ElianHugh/enumr/workflows/R-CMD-check/badge.svg)](https://github.com/ElianHugh/enumr/actions)
[![Codecov test coverage](https://codecov.io/gh/ElianHugh/enumr/branch/main/graph/badge.svg)](https://codecov.io/gh/ElianHugh/enumr?branch=main)
<!-- badges: end -->

## Overview

{enumr} implements static enumerations in R. At their most basic, enums are lists that have unique name/value pairs (called 'members'), and cannot be modified after their definition.

Why use enums? Some examples:

- Improve code self-documentation by explicitly defining key:value pairs
- Reduce the occurrence of code-breaking typos
- Prevent accidental overwriting of variables

## Installation

```r
if (!requireNamespace('pak')) {
    install.packages('pak', repos = 'https://r-lib.github.io/p/pak/dev/')
}
pak::pkg_install('ElianHugh/enumr')
```

## Usage

Enumr implements two classes of enum: numeric and generic. Both are created with the `enum()` function, and are defined by the arguments supplied to `enum()`; if all arguments evaluate as numeric, the enum is numeric, otherwise it is generic.

Numeric enums only permit numeric values in their name/value pairs. Numeric values include formulas/equations that evaluate to a numeric value. Numeric enum members do *not* need to have values explicitly defined. Instead, each member's value is either the index of the member, or the value of the previous member plus 1 - this is called 'implicit definition'.

```r
enum(
    cat,
    dog,
    bird
)

#> # A numeric enum: 3 members
#>  int cat : 1
#>  int dog : 2
#>  int bird : 3

```

Generic enum members can be of any type, even including enums themselves. Each name/value pair must be explicitly defined, and each value must *evaluate* to a value.

```r
enum(
    a = mtcars,
    b = PlantGrowth,
    c = airquality
)

#> # A generic enum: 3 members
#>   tibble a : <32 × 11>
#>   tibble b : <30 × 2>
#>   tibble c : <153 × 6>
```

See the [pkgdown site](https://elianhugh.github.io/enumr/) for more information on enums, and other features of the {enumr} package, such as NSE or typed integration.

## Inspiration

- [This stack overflow post](https://stackoverflow.com/questions/33838392/enum-like-arguments-in-r/44152358)
- [aryoda/R_enumerations](https://github.com/aryoda/R_enumerations)
- [Typescript enums](https://www.typescriptlang.org/docs/handbook/enums.html)


## Code of Conduct

Please note that the enumr project is released with a [Contributor Code of Conduct](https://contributor-covenant.org/version/2/0/CODE_OF_CONDUCT.html). By contributing to this project, you agree to abide by its terms.
