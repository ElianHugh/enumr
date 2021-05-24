#' Coerce lists, environments, and factors to enumerations
#'
#' @description
#' `as_enum()` turns an existing object into an enumeration. Coercion
#' can be used when you want to create an enum, but don't know
#' what the exact values each member will contain at runtime. This is comparable
#' to the [`as.list`][base::as.list()] method.
#'
#' As an S3 generic, `as_enum()` holds methods for:
#' * [`list`][base::list()]: wrapper function that passes the list to
#'   [new_generic_enum()]
#' * [`data.frame`][base::data.frame()]: coerces a data.frame to a list (
#'   dropping row names in the process), and supplies the list of objects
#'   to [new_generic_enum()]
#' * [`environment`][base::environment()]: coerces an environment to a list,
#'   and supplies the list of objects to [new_generic_enum()]
#' * [`factor`][base::factor()]: constructs a list of name/value pairs
#'   from a factor, supplies the list to [new_numeric_enum()].
#' * Default: attempt to coerce to a list, then to an enum
#'
#'
#' @param x the object to coerce to enum
#' @param .sorted whether the object elements should be sorted
#' @param use_cols  cols of the data frame are used for name/value pairs instead
#' of the data frame's observations
#' @param use_rows rows of the data frame are used for name/value pairs
#' instead of the data frame's observations
#' @param ... parameters to pass to further methods
#' @return An enumeration (enum), a list of unique name/value pairs
#' @seealso [enum()] create an enum from supplied arguments.
#' [new_generic_enum()] and [new_numeric_enum()] create enums from
#' a list of arguments.
#' @export
#' @examples
#' as_enum(list(x = 5, y = "str"))
#'
#' as_enum(rlang::env(a = 1, b = "str"))
#'
#' as_enum(factor(c("January", "February", "December"), levels = month.name))
#'
#' as_enum(mtcars)
#'
#' as_enum(mtcars, use_cols = TRUE)
#'
#' as_enum(mtcars, use_rows = TRUE)
as_enum <- function(x, ...) {
    UseMethod("as_enum")
}

#' @export
#' @rdname as_enum
as_enum.list <- function(x, ...) {
    new_generic_enum(x)
}

#' @export
#' @param .all_names whether to include variables with a dot `.`
#' @rdname as_enum
as_enum.environment <- function(x, ..., .all_names = FALSE, .sorted = TRUE) {
    new_generic_enum(
        as.list.environment(x, all.names = .all_names, sorted = .sorted)
    )
}

#' @export
#' @rdname as_enum
as_enum.factor <- function(x, ..., .sorted = TRUE) {
    if (.sorted) x <- sort(x)

    res <- vector("list", length(x))
    for (i in seq_along(x)) {
        res[[i]] <- as.numeric(x[[i]])
        names(res)[i] <- as.character(x[[i]])
    }

    new_numeric_enum(res)
}

#' @export
#' @rdname as_enum
as_enum.data.frame <- function(x, ..., use_cols = FALSE, use_rows = FALSE) {
    if (use_cols && use_rows) error_invalid_args()

    if (use_cols) {
        res <- vector("list", length(x))
        for (i in seq_along(x)) {
            res[[i]] <- as.character(names(x[i]))
            names(res)[i] <- names(x[i])
        }
        new_generic_enum(res)
    } else if (use_rows) {
        rows <- row.names(x)
        res <- vector("list", length(rows))
        for (i in seq_along(rows)) {
            res[[i]] <- rows[i]
            names(res)[i] <- rows[i]
        }
        new_generic_enum(res)
    } else {
        x <- unclass(x)
        attr(x, "row.names") <- NULL
        as_enum.list(x)
    }
}

#' @export
#' @rdname as_enum
as_enum.NULL <- function(x, ...) {
    new_generic_enum(list())
}

#' @export
#' @rdname as_enum
as_enum.default <- function(x, ...) {
    error_impossible_coercion(x)
}
