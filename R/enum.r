#' Create a new enumeration
#'
#' @description
#'
#' `enum()` creates a new enumeration, and infers the the enumeration type
#' based on the arguments supplied to it. Enumerations are similar to lists,
#' but:
#'
#'   * cannot be assigned to after definition
#'   * all values and names must be unique
#'
#' There are two types of enumeration: generic and numeric. The main difference
#' between the two is that generic enumerations must have all their values
#' explicitly defined. Numeric enums, by contrast, infer the values of
#' their members, and must have only numeric values.
#'
#' Numeric enum values are inferred when a member does not have a value assigned
#' to it. The value of the member is then calculated as +1 to the last
#' member's value, or the current member's index. Incrementation for values is
#' prioritised over index as value.
#'
#' @details
#'
#' Under the surface, enums are actually lists contained within
#' locked environments. This is so that the enum bindings cannot be modified,
#' and the enum order is maintained. S3 methods are defined for
#' `$`, `[`, and `[[`, which access the enum list directly.
#'
#' @param ... list of enumeration arguments
#' @return An enumeration (enum), a list of unique name/value pairs.
#' @examples
#' # Generic Enum
#' enum(apple = "apple", pear = "pear")
#'
#' enum(dat1 = mtcars, dat2 = iris, dat3 = PlantGrowth)
#'
#' # Numeric Enum
#' enum(style, warning, error)
#'
#' enum(a = 50, b = .$a * 2)
#' @export
#' @seealso
#' [new_numeric_enum()], [new_generic_enum()], [as_enum()]
enum <- function(...) {
    dots <- as.list(substitute(...()))

    validate_enum_definition(dots)

    if (.is_numeric_enum(dots)) {
        new_numeric_enum(dots)
    } else {
        new_generic_enum(dots)
    }
}
