#' Enum assertion type checking
#'
#' @description
#' Assertion for controlling input and return types.
#' @name Enum
#' @rdname Enum_Assertion
#' @param ... a value to check type assertions with
#' @return any
#' @export
#' @importFrom typed process_assertion_factory_dots
#' @examples
#' # If you leverage the {typed} package, you can make use
#' # of the `Enum()` assertion for type checking:
#'
#' library(typed, quietly = TRUE, warn.conflicts = FALSE)
#'
#' # Variable 'x' must correspond to an enum
#' Enum() ? x <- enum(a, b, c)
#'
#' # Variable 'x' must correspond to a variable in an enum
#' Enum(enum(a, b, c)) ? x <- 2
#'
#' # Argument 'x' must correspond to a variable in an enum
#' my_function <- ? function(x = ? Enum(enum(a, b, c))) {
#'     print("success!")
#' }
#'
#' # Function must return an enum
#' func_return <- Enum() ? function() {
#'     return(
#'         enum(a, b, c)
#'     )
#' }
Enum <- function(...) {
    if (!requireNamespace("typed", quietly = TRUE)) {
        rlang::warn("Enum assertion requires the typed package be loaded")
    } else {
        .assert_enum(...)
    }
}

.assert_enum <- typed::as_assertion_factory(
    function(value, supplied_enum = NULL, null_ok = FALSE) {
        if (null_ok && is.null(value)) {
            return(NULL)
        }
        if (!inherits(value, "enum") && is.null(supplied_enum)) {
            e <- sprintf(
                "%s\n%s",
                "class mismatch",
                waldo::compare(
                    x = class(value),
                    y = "enum",
                    x_arg = "class(value)",
                    y_arg = "expected"
                )
            )
            stop(e, call. = FALSE)
        }
        supplied_values <- lapply(
            as.list(supplied_enum),
            unlist,
            use.names = FALSE
        )

        if (!is.null(supplied_enum) &&
            !any(!is.na(match(supplied_values, value)))) {
            e <- sprintf(
                "%s\n%s",
                "value does not match enum",
                waldo::compare(
                    x = value,
                    y = unlist(supplied_values, use.names = FALSE),
                    x_arg = "value",
                    y_arg = "required values:"
                )
            )
            stop(e, call. = FALSE)
        }
        value
    }
)

#' Test if the object is an enum
#'
#' Returns TRUE if the object inherits from the
#' enum class, and FALSE if it does not. Does not
#' distinguish between numeric or generic enums.
#'
#' @param x value to check if is enum
#' @export
is_enum <- function(x) {
    inherits(x, "enum")
}
