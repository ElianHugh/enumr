#' Printing enums
#' @description
#'
#' Pretty print enums with the print.enum method.
#' Displays the enum class, number of members defined,
#' and member properties.
#'
#' The `format.enum()` method does the majority of
#' the work for pretty printing.
#'
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
    obj_len <- length(enum_list)

    vals <- lapply(enum_list, condense_object)
    enum_names <- names(vals)
    enum_type <- if (any(class(x) == "numeric_enum")) "numeric" else "generic"

    types <- lapply(enum_list, class_abbr)
    abbr_width <- nchar(types[which.max(nchar(types))])
    abbr_types <- lapply(types, equalise_widths, abbr_width)

    pl <- if (obj_len > 1 || obj_len < 1) "members" else "member"

    toReturn <- c(
        crayon::style(
            glue::glue("# A {enum_type} enum: {length(x)} {pl}"),
            "grey60"
        ),
        glue::glue(
            " {crayon::style(abbr_types, 'grey60')} {enum_names} : {vals[enum_names]}"
        )
    )
}

# Misc methods for object abbrievation -----------------------------------------

condense_object <- function(x) {
    if (inherits(x, "data.frame")) {
        x_dim <- dim(x)
        crayon::style(
            glue::glue("<{x_dim[1]} \u00d7 {x_dim[2]}>"),
            "grey60"
        )
    } else if ((is.vector(x) || is.factor(x)) && length(x) > 3) {
        crayon::style(
            glue::glue("{length(x)} obs"),
            "grey60"
        )
    } else if (inherits(x, "enum")) {
        obj_len <- length(x)
        pl <- if (obj_len > 1 || obj_len < 1) "members" else "member"
        crayon::style(
            glue::glue("{length.enum(x)} {pl}"),
            "grey60"
        )
    } else if (inherits(x, "function")) {
        args <- paste(names(formals(x)), collapse = ", ")
        paste0(
            "function(",
            args,
            ")"
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
        "name" = "sym",
        "pairlist" = "plist",
        "promise" = "prom",
        "language" = "lang",
        "call" = "lang",
        "expression" = "expr",
        "data.frame" = "df",
        "matrix" = "mtrx",
        "array" = "arr",
        "formula" = "form",
        "factor" = "fct",
        "function" = "fn",
        # Common pkg types
        "tbl_df" = "tibble",
        "data.table" = "dt",
        # Custom
        "numeric_enum" = "enum",
        "generic_enum" = "enum",
        class(x)
    )
}

equalise_widths <- function(x, .width) {
    return(formatC(x, width = -.width))
}