# (WIP) Enumr <img src='man/figures/logo.png' align="right" height="120" />

<!-- badges: start -->
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental) [![R-CMD-check](https://github.com/ElianHugh/enumr/workflows/R-CMD-check/badge.svg)](https://github.com/ElianHugh/enumr/actions)
<!-- badges: end -->

## Rationale

Why use enums? Some examples:

- Improve code self-documentation by explicitly defining key:value pairs
- Reduce the occurence of code-breaking typos
- Prevent accidental overwriting of variables

## Usage

```r
if (!requireNamespace('pak')) {
    install.packages('pak', repos = 'https://r-lib.github.io/p/pak/dev/')
}
pak::pkg_install('ElianHugh/enumr')
```

### Basics

At their most basic, enums are lists that have unique key/pair values ('members'), and cannot be modified after their definition.

```r
# Set up enum
error_codes <- enum(
    bad_request = 400,
    forbidden = 403,
    not_found = 404
)

# Access values
error_codes$bad_request
#> [1] 400

# Cannot change enum members after definition
error_codes$bad_request <- 101

#> Error: Enum members cannot be assigned to after their definition.
#> Run `rlang::last_error()` to see where the error occurred.
```

#### Generic Enums

There are two types of enums: generic enums, and numeric enums. Generic enum members (the variables inside the enum) can be of any type, even including enums themselves. Each key/value pair must be explicitly defined, or the enum will result in an error.

```r
a <- enum(
    a = "hello",
    b
)

#> Error in enum(a = "hello", b) :
#>  Incorrect arguments supplied. All generic enum members must be initialised.
```

#### Numeric Enums

Numeric enums, in contrast, only allow numeric values in their key/value pairs. Numeric values include formulas/equations that evaluate to a numeric value. For instance:

```r
a <- enum(
    a = 5,
    b = 2 * 2,
    c = 500 / 3
)
```

Numeric enums also differ in that their members do *not* need to have values explicitly defined. Instead, each member value is either the index of the member, or the value of the previous member + 1 (implicit definition). E.g.

```r
# An enum without values defined

a <- enum(
    a,
    b,
    c
)

print(a)

#> # A numeric enum: 3 members
#>   int a : 1
#>   dbl b : 2
#>   dbl c : 3

# This incrementation also works with calls

b <- enum(
    a,
    b = 50 / 2,
    c
)

print(b)


#> # A numeric enum: 4 members
#>   int a : 1
#>   dbl b : 25
#>   dbl c : 26

```

### NSE

You can use `.` to refer to the current enum<sup>1</sup>. Specifically, when defining variables, you can use `.$` to refer to other elements in the enum. E.g.,

```r
# Numeric enum
a <- enum(
    a,
    b,
    c = .$a + 10,
    d = .$c * .$b
)

print(a)

#> # A numeric enum: 4 members
#>  int a : 1
#>  int b : 2
#>  dbl c : 11
#>  dbl d : 22

# Generic enum
a <- enum(
    a = "Hello",
    b = c(.$a, "world")
)

a$b
#> "Hello" "world"

```

It should be noted, however, there are limitations to defining members with `.$`. Firstly, enum member validation is performed *sequentially*. That is, each non-explicit member is initialised in order of their definition. As a result, computed members cannot refer to later non-explicit members. For instance:

```r
# Invalid definition!
a <- enum(
    a,
    b = .$c + 1,
    c
)

#> Error: Incorrect arguments supplied to enum. Each argument value must be unique.
#> Run `rlang::last_error()` to see where the error occurred.

# Valid due to explicit initialisation
a <- enum(
    a,
    b = .$c + 1,
    c = 50
)
```

Moreover, due to sequential initialisation, enum members do not support cyclical evaluation. In essence, the chain of computed members *must* end with a computable value:

```r
# Invalid
x <- enum(
    a = .$b + 1,
    b = .$c + 1,
    c = .$a + 1
)

#> Error in .$b + 1 : non-numeric argument to binary operator

# Valid
x <- enum(
    a = .$c + 1,
    b = .$a + 1,
    c = 5
)

#> # A numeric enum: 3 members
#>  dbl a : 6
#>  dbl b : 7
#>  dbl c : 5
```

<sup>1</sup> Technically, `.` (dot) refers to the arguments supplied in the enum constructor. The arguments are converted to a list, and the dot operator acts as a reference to said list.

### Typed Integration

If you are using typed, you can make use of the `Enum` assertion for return and input assertion. Note that 'enum' is the definition and 'Enum' is the assertion.

```r
# Constrain x to Enum

Enum() ? x <- 5 # invalid
#> Error: class mismatch
#> `class(value)`: "numeric"
#> `expected`:     "enum"

# Constrain input to an input in enum 'a'

a <- enum(
    a = "string",
    b = 2,
    c = 5 + 5
)

my_function <- ? function(x = ? Enum(a)) {
    print('hello!')
}

my_function('a string') # invalid

#> Error: In `my_function("a string")` at `check_arg(x, Enum(a))`:
#> wrong argument to function, value does not match enum
#> `value` is a character vector ('a string')
#> `required values:` is a list

# Constrain function return to Enum class

x <- Enum() ? function() {
    5
}

x()

#> Error: In `x()` at `check_output(5, Enum())`:
#> wrong return value, class mismatch
#> `class(value)`: "numeric"
#> `expected`:     "enum"
```

## Performance and Overhead

Enum definition is reasonably fast, so will likely not be a bottleneck for the large majority of users. However, if speed is of concern, there are some things to keep in mind:

- Symbols and calls require evaluation, which generally slow enum creation
- Inferred numerics are slower than explicit numerics
- Generic enums are *typically* faster than numeric enums

```r
create_symbols <- function() { mapply(function(x, y) assign(x, as.character(y), .GlobalEnv), c('a','b','c','d','e'), seq(5)) }

microbenchmark::microbenchmark(
    inferred <- enum(a, b, c, d, e),
    explicit_num_symbols <- enum(
        a = 1,
        b = .$a + 1,
        c = .$b + 1,
        d = .$c + 1,
        e = .$d + 1
        ),
    explicit_numeric <- enum(a = 1, b = 2, c = 3, d = 4, e = 5),
    {
        create_symbols()
        generic_symbols <- enum(a = a, b = b, c = c, d = d, e = e)
    },
    generic <- enum(a = "1", b = "2", c = "3", d = "4", e = "5")
)
```
<center>

| Rank | Enum Type | Mean Speed<sup>*</sup>|
|------|-----------|-----------------------|
|1|Generic|1019.611|
|2|Generic w/ Symbols|1027.226|
|3|Explicit Numeric|1508.888|
|4|Explicit w/ Symbols|1593.736 |
|5|Implicit Numeric|2289.961|

<sup>*</sup> *Speed measured in microseconds*, will vary depending on computer specs
</center>

To speed up performance further, you can also access the enum constructor methods directly: `new_generic_enum()` and `new_numeric_enum()`. However, this forgoes some of the
niceties of the `enum()` helper function, such as NSE or implicit definition.

## Inspiration

- [This stack overflow post](https://stackoverflow.com/questions/33838392/enum-like-arguments-in-r/44152358)
- [aryoda/R_enumerations](https://github.com/aryoda/R_enumerations)
- [Typescript enums](https://www.typescriptlang.org/docs/handbook/enums.html)
