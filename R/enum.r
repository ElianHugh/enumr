#' Enumeration
#'
#' @description
#' Define an enumeration to access values from. Values cannot be reassigned.
#' Values can be anything (within reason).
#'
#' @details
#' Enums defined without initialisers are considered numeric enums, and have
#' their values set to incrementing numbers. Numeric enums can also be a mix of
#' defined numeric values and undefined members.
#'
#' Under the surface, enums are actually lists contained within
#' locked environments.This is so that the enum bindings cannot be modified,
#' and the enum order is maintained. S3 methods are defined for
#' `$`, `[`, and `[[`, which access the enum list directly.
#' @param ... list of enumeration arguments
#'
#' @return enum
#' @examples
#' # Generic Enum
#' enum(apple = "apple", pear = "pear")
#' enum(dat1 = mtcars, dat2 = iris, dat3 = PlantGrowth)
#'
#' # Numeric Enum
#' enum(style, warning, error)
#' enum(a = 50, b = .$a * 2)
#' @export
#' @seealso
#' [new_numeric_enum()], [new_generic_enum()]
enum <- function(...) {
    dots <- rlang::enexprs(...)
    if (.is_numeric_enum(dots)) {
        new_numeric_enum(dots)
    } else {
        new_generic_enum(dots)
    }
}
