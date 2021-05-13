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
#' @rdname printing
format.enum <- function(x, ...) {
    enum_list <- as.list.enum(x, ...)
    vals <- lapply(enum_list, condense_object)
    enum_names <- names(vals)
    types <- lapply(enum_list, class_abbr)
    enum_type <- if (any(class(x) == "numeric_enum")) "numeric" else "generic"

    toReturn <- c(
        crayon::style(
            glue::glue("# A {enum_type} enum: {length(x)} members"),
            "grey60"
        ),
        glue::glue(
            " {crayon::style(types, 'grey60')} {enum_names} : {vals[enum_names]}"
        )
    )
}

condense_object <- function(x) {
    if (inherits(x, "data.frame")) {
        x_dim <- dim(x)
        crayon::style(
            glue::glue("<{x_dim[1]} \u00d7 {x_dim[2]}>"),
            "grey60"
        )
    } else if (inherits(x, "list")) {
         crayon::style(
             glue::glue("{length(x)} obs"),
             "grey60"
         )
    } else if (inherits(x, "enum")) {
        crayon::style(
            glue::glue("{length.enum(x)} members"),
            "grey60"
        )
    } else {
        x
    }
}

class_abbr <- function(x) {
    x_class <- data.class(x)
    switch(x_class,
            # Vector types
            "logical" = "lgl",
            "numeric" = "num",
            "character" = "chr",
            "complex" = "cpl",
            "raw" = "raw",
            # Other
            "list" = "list",
            "NULL" = "NULL",
            "closure" = "fn",
            "special" = "spcl",
            "environment" = "env",
            "S4" = "S4",
            "symbol" = "symbol",
            "pairlist" = "plist",
            "promise" = "prom",
            "language" = "lang",
            "expression" = "expr",
            "data.frame" = "df",
            "matrix" = "mtrx",
            "array" = "arr",
            "formula" = "form",
            "factor" = "fct",
            # Common pkg types
            "tbl_df" = "tibble",
            "data.table" = "dt",
            # Custom
            "numeric_enum" = "enum",
            "generic_enum" = "enum",
            x_class
        )
}