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

    enum_length <- length(as.list.enum(object))
    enum_type <- data.class(object)
    enum_members_text <- if (enum_length > 1L || enum_length < 1L) "members\n" else "member\n"
    object <- as.list.enum(object)

    cat(
        enum_type, ":", enum_length, enum_members_text
    )

    invisible(
        NextMethod(
            "str", ...,
            no.list = TRUE,
            nest.lev = 0L
        )
    )
}
