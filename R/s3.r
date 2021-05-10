#' General S3 Methods for Enums
#'
#' @description
#' Various S3 methods that improve interacting with
#' enum data types
#' @details
#' These are some details
#' @param x enum
#' @param object enum
#' @param ... arguments to pass to as.list
#' @name S3-Methods
NULL

#' @export
#' @rdname S3-Methods
str.enum <- function(object, ...) {
    if (!is_enum(object)) {
        warning("str.enum() called with non-enum.")
    }


    obj_len <- length(as.list.enum(object))
    cl <- data.class(object)
    pl <- if (obj_len > 1) "members\n" else "member\n"
    cat(
        cl, ":", obj_len, pl
    )

    object <- as.list.enum(object)

    invisible(
        NextMethod(
            "str", ...,
            no.list = TRUE,
            nest.lev = 0
        )
    )
}


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
