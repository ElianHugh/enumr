condense_object <- function(x) {
    if (inherits(x, "data.frame")) {
        pillar::style_subtle(
            glue::glue("<{pillar::dim_desc(x)}>")
        )
    } else {
        x
    }
}

## S3 methods for enum
#' @export
print.enum <- function(x, ...) {
    enum_list <- as.list.enum(x)
    vals <- lapply(enum_list, condense_object)
    enum_names <- names(vals)
    types <- lapply(enum_list, pillar::type_sum)
    enum_type <- ifelse(any(class(x) == "numeric_enum"), "numeric", "generic")

    writeLines(
        pillar::style_subtle(glue::glue("# A {enum_type} enum: {length(x)} members"))
    )
    writeLines(
        glue::glue(
            "  {pillar::style_subtle(types)} {enum_names} : {vals[enum_names]}"
        )
    )
    invisible(x)
}

#' @export
`[.enum` <- function(x, arg) {
    as.list.enum(x)[arg]
}

#' @export
`[[.enum` <- function(x, arg) {
    as.list.enum(x)[[arg]]
}

#' @export
`$.enum` <- function(x, arg) {
    as.list.enum(x)[[arg]]
}

#' @export
length.enum <- function(x) {
    length(as.list.enum(x))
}

#' @export
names.enum <- function(x) {
    names(as.list.enum(x))
}

#' @export
as.list.enum <- function(x, all.names = FALSE, sorted = FALSE, ...) {
     as.list.environment(x, all.names, sorted)$enum
}
