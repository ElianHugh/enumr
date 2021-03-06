#' General S3 Methods for Enums
#'
#' @description
#' Various S3 methods that improve interacting with
#' enum data types.
#'
#' These rely on coercing enums to list types before
#' applying any methods to the enum.
#' @param x enum
#' @param ... arguments to pass to as.list
#' @name S3-Methods
NULL

# Standard list() methods --------------------------------------------

#' @export
#' @rdname S3-Methods
length.enum <- function(x) {
    length(as.list.enum(x))
}

#' @export
#' @rdname S3-Methods
names.enum <- function(x) {
    names(as.list.enum(x))
}

#' @export
#' @rdname S3-Methods
as.list.enum <- function(x, ...) {
    as.list.environment(x, ...)$enum
}

#' @export
#' @rdname S3-Methods
as.character.enum <- function(x, ...) {
    as.character.default(as.list.enum(x, ...))
}

#' @export
#' @rdname S3-Methods
as.numeric.enum <- function(x, ...) {
    as.numeric(as.list.enum(x, ...))
}

#' @export
#' @rdname S3-Methods
as.data.frame.enum <- function(x, ...) {
    enum_list <- as.list.environment(x)$enum
    list_names <- names(enum_list)
    list_values <- unlist(enum_list, use.names = TRUE)

    data.frame(
        row.names = list_names,
        values = list_values
    )
}
