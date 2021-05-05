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

At their most basic, enums are lists that have unique key/pair values (called 'members'), and cannot be modified after their definition.

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

#> Error in error_codes$bad_request <- 101 :
#>  cannot add bindings to a locked environment
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

Numeric enums also differ in that their members do *not* need to have values explicitly defined. Instead, each member value is either the index of the member, or the value of the previous member + 1. E.g.

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

You can use `.` to refer to the current enum. Specifically, when defining variables, you can use `.$` to refer to other elements in the enum. E.g.,

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
# > "Hello" "world"

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

# > Error in .$b + 1 : non-numeric argument to binary operator

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

## Inspiration

- [This stack overflow post](https://stackoverflow.com/questions/33838392/enum-like-arguments-in-r/44152358)
- [aryoda/R_enumerations](https://github.com/aryoda/R_enumerations)
- [Typescript enums](https://www.typescriptlang.org/docs/handbook/enums.html)
