#' enumr: Enumerations for R
#'
#' @details
#'
#' The __enumr__ package implements enumerations (or 'enums').
#' Enums are lists that have unique key/pair values (called 'members'),
#' and cannot be modified after their definition.
#'
#'
#' General Resources:
#'   * Enumr's enums are heavily inspired by the typescript
#'     data structure of the same name.
#'     See [here](https://www.typescriptlang.org/docs/handbook/enums.html)
#'     for how enums function in typescript
#'   * Enumr's [pkgdown site](https://elianhugh.github.io/enumr/index.html)
#'
#'
#' Main exported methods:
#'   * making enums: [enum()], [as_enum()], [new_generic_enum()],
#'     [new_numeric_enum()]
#'   * type checking: [enumr::Enum()], [is_enum()]
#'   * printing and presenting enums: [print.enum()], [format.enum()]
#'
#' @docType package
#' @name enumr
#' @aliases NULL enumr-package
"_PACKAGE"