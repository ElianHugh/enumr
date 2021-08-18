#' Display an enum's internal structure
#'
#' Display the internal structure of an enum,
#' listing enum members and the variables defined
#' within them.
#'
#' @param object an enum to examine
#' @param ... dots to pass to further methods
#' @param nest_lev the nest level that str should start at
#' @return NULL
#' @export
str.enum <- function(object, ..., nest_lev = 0L) {
    if (!is_enum(object)) {
        rlang::abort("str.enum() called with non-enum object.")
    }

    if (nest_lev != 0L) cat(" ")

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
