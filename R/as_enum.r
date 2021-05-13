#' Coerce lists, environments, and factors to enumerations
#'
#' @description
#' `as_enum()` turns an existing object into an enumeration.
#' An enumeration holds unique key/value pairs that cannot be re-defined.
#'
#' As an S3 generic, `as_enum()` holds methods for:
#' * [`list`][base::list()]: wrapper function that passes the list to
#'   [new_generic_enum()]
#' * ['environment'][base::environment()]: coerces an environment to a list,
#'   and supplies the list of objects to [new_generic_enum()]
#' * ['factor'][base::factor()]: constructs a list of name/value pairs
#'   from a factor, supplies the list to [new_numeric_enum()]
#'
#' @param x the object to coerce to enum
#' @param .sorted whether the object elements should be sorted
#' @param ... parameters to pass to further methods
#' @seealso [enum()] create an enum from supplied arguments.
#' [new_generic_enum()] and [new_numeric_enum()] create enums from
#' a list of arguments.
#' @export
#' @examples
#' as_enum(list(x = 5, y = "str"))
#' as_enum(.GlobalEnv)
#' as_enum()
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

    new_numeric_enum(
        res
    )
}

#' @export
#' @rdname as_enum
as_enum.NULL <- function(x, ...) {
    new_numeric_enum(list())
}
