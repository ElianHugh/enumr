#' Enum assertion type checking
#'
#' @description
#' Assertion for controlling object, argument, and return types.
#' Allows for the type checking of enums and enum members.
#'
#' This function requires the {typed} package to operate. See
#' [`typed::?()`] for more details.
#'
#' @name Enum
#' @rdname Enum_Assertion
#' @param ... a value to check type assertions with
#' @return any
#' @export
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
    if (!isNamespaceLoaded("typed")) {
        rlang::warn(
            "Enum assertion requires the {typed} package be loaded first"
        )
    } else {
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
        })
        .assert_enum(...)
    }
}

#' Test object inheritance
#'
#' @param x object to check
#' @name is_enum
#' @aliases is_numeric_enum is_generic_enum
NULL

#' @export
#' @return TRUE if the object inherits from the
#' enum class, and FALSE if it does not.
#' @rdname is_enum
is_enum <- function(x) {
    inherits(x, "enum")
}

#' @export
#' @return TRUE if the object inherits from the
#' numeric enum class, and FALSE if it does not.
#' @rdname is_enum
is_numeric_enum <- function(x) {
    inherits(x, "numeric_enum")
}

#' @export
#' @return TRUE if the object inherits from the
#' generic enum class, and FALSE if it does not.
#' @rdname is_enum
is_generic_enum <- function(x) {
    inherits(x, "generic_enum")
}
