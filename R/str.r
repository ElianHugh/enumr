#' @export
str.enum <- function(object, ..., nest.lev = 0L) {
    if (!is_enum(object)) {
        rlang::abort("str.enum() called with non-enum.")
    }

    if (nest.lev != 0L) cat(" ")

    obj_len <- length(as.list.enum(object))
    cl <- data.class(object)
    pl <- if (obj_len > 1L || obj_len < 1L) "members\n" else "member\n"
    cat(
        cl, ":", obj_len, pl
    )
    object <- as.list.enum(object)

    invisible(
        NextMethod(
            "str", ...,
            no.list = TRUE,
            nest.lev = 0L
        )
    )
}