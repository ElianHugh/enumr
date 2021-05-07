#' Enum assertion
#' @description
#' Assertion for controlling input and return types.
#' @name Enum
#' @rdname Enum_Assertion
#' @param ... the value to check assertions with
#' @param supplied_enum the enum to compare values against
#' @param null_ok whether null values are accepted
#' @return any
#' @export
#' @importFrom typed process_assertion_factory_dots
#' @examples
#' \dontrun{
#' Enum() ? x <- enum(a, b, c)
#' my_function <- ? function(x = ? Enum(a)) {}
#' x <- Enum() ? function() {}
#' }
Enum <- typed::as_assertion_factory(function(value, supplied_enum = NULL, null_ok = FALSE) {
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
    supplied_values <- lapply(as.list(supplied_enum), unlist, use.names = FALSE)

    if (!is.null(supplied_enum) && !any(!is.na(match(supplied_values, value)))) {
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

#' is enum
#' @param x value to check if is enum
#' @export
is_enum <- function(x) {
    inherits(x, "enum")
}