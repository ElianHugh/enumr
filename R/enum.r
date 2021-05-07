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
#' Under the surface, enums are actually lists contained within locked environments.
#' This is so that the enum bindings cannot be modified, and the enum order is maintained.
#' S3 methods are defined for `$`, `[`, and `[[`, which access the enum list directly.
#' @param ... list of enumeration arguments
#'
#' @return enum
#' @examples
#' fruits <- enum(apple = "apple", pear = "pear")
#' errors <- enum(style, warning, error)
#' data <- enum(dat1 = mtcars, dat2 = iris, dat3 = PlantGrowth)
#' mixed_enum <- enum(a = 5, b = mtcars, c = 50, d = "elephant")
#' computed_enum <- enum(a = 50, b = .$a * 2)
#' @export
#' @seealso \code{\link[base]{environment}}, \code{\link[base]{list}},  \code{\link[base]{factor}}
enum <- function(...) {
    dots <- rlang::enexprs(...)
    if (is_numeric_enum(dots)) {
        new_numeric_enum(dots)
    } else {
        new_generic_enum(dots)
    }
}
