#' General S3 Methods for Enums
#'
#' @description
#' Various S3 methods that improve interacting with
#' enum data types
#' @details
#' These are some details
#' @param x enum
#' @param ... arguments to pass to as.list
#' @name S3-Methods
NULL

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
    as.character(as.list.enum(x, ...))
}

#' @export
#' @rdname S3-Methods
as.complex.enum <- function(x, ...) {
    as.complex(as.list.enum(x, ...))
}
