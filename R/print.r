#' Printing enums
#' @description
#' Pretty print enums with the print.enum method
#' @param x enum to print
#' @param ... values passed to further methods
#' @name printing
NULL

#' @export
#' @rdname printing
print.enum <- function(x, ...) {
    cat(format.enum(x, ...), sep = "\n")
    invisible(x)
}

#' @export
#' @describeIn printing
format.enum <- function(x, ...) {
    enum_list <- as.list.enum(x, ...)
    vals <- lapply(enum_list, condense_object)
    enum_names <- names(vals)
    types <- lapply(enum_list, pillar::type_sum)
    enum_type <- if (any(class(x) == "numeric_enum")) "numeric" else "generic"

    toReturn <- c(
        pillar::style_subtle(
            glue::glue("# A {enum_type} enum: {length(x)} members")
        ),
        glue::glue(
            " {pillar::style_subtle(types)} {enum_names} : {vals[enum_names]}"
        )
    )
}

condense_object <- function(x) {
    if (inherits(x, "data.frame")) {
        pillar::style_subtle(
            glue::glue("<{pillar::dim_desc(x)}>")
        )
    } else {
        x
    }
}
