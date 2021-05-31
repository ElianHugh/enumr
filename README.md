# enumr (WIP) <img src='man/figures/logo.png' align="right" height="120" />

<!-- badges: start -->
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![codecov](https://codecov.io/gh/ElianHugh/enumr/branch/main/graph/badge.svg?token=FWRJW5SV3X)](https://codecov.io/gh/ElianHugh/enumr)
[![R-CMD-check](https://github.com/ElianHugh/enumr/workflows/R-CMD-check/badge.svg)](https://github.com/ElianHugh/enumr/actions)
<!-- badges: end -->

## Overview

{enumr} implements static enumerations in R. At their most basic, enums are lists that have unique name/value pairs (called 'members'), and are 'static' in that they cannot be modified after their definition.

Why use enums? Some examples:

- Improve code self-documentation by explicitly defining name/value pairs
- Reduce the occurrence of code-breaking typos
- Prevent accidental overwriting of variables
- Easily change values in the future

## Installation

### Release build

```r
install.packages('enumr', repos = 'https://elianhugh.r-universe.dev')
```
### Development build

```r
pak::pkg_install('ElianHugh/enumr')
# or
devtools::install_github('ElianHugh/enumr)
```

## Usage

Enumr implements two classes of enum: numeric and generic. Both are created with the `enum()` function, {enumr} handles the identification. You don't need to worry about how they work in implementation, just know that there are rules for what constitutes a numeric vs. generic enum.

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
#>  df a : <32 × 11>
#>  df b : <30 × 2>
#>  df c : <153 × 6>
```

See the [pkgdown site](https://elianhugh.github.io/enumr/) for more information on enums, and other features of the {enumr} package, such as coercion, NSE, and typed integration.

## Inspiration

- [This stack overflow post](https://stackoverflow.com/questions/33838392/enum-like-arguments-in-r/44152358)
- [aryoda/R_enumerations](https://github.com/aryoda/R_enumerations)
- [Typescript enums](https://www.typescriptlang.org/docs/handbook/enums.html)


## Code of Conduct

Please note that the enumr project is released with a [Contributor Code of Conduct](https://elianhugh.github.io/enumr/CODE_OF_CONDUCT.html). By contributing to this project, you agree to abide by its terms.
