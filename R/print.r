#' Printing enums
#' @description
#'
#' Pretty print enums with the print.enum method.
#' Displays the enum class, number of members defined,
#' and member properties.
#'
#' @param x enum to print
#' @param ... values passed to further methods
#' @return silently returns x
#' @name printing
NULL

#' @export
#' @rdname printing
print.enum <- function(x, ...) {
    enum_list <- as.list.enum(x, ...)

    obj_len <- length(enum_list)
    enum_type <- if (any(class(x) == "numeric_enum")) "numeric" else "generic"
    enum_members_text <- if (obj_len > 1 || obj_len < 1) "members" else "member"

    top_level_text <- sprintf(
        "# A %s enum: %s %s",
        enum_type,
        obj_len,
        enum_members_text
    )

    enum_values <- lapply(enum_list, condense_object)
    snipped_values <- snip_str(enum_values)
    wrapped_names <- wrap_str(names(enum_list))
    type_abbrs <- lapply(enum_list, class_abbr)
    wrapped_abbr_types <- wrap_str(type_abbrs)

    enum_value_text <- sprintf(
        " %s %s : %s",
        crayon::style(wrapped_abbr_types, "grey60"),
        wrapped_names,
        snipped_values
    )

    cat(
        c(
            crayon::style(
                top_level_text,
                "grey60"
            ),
            enum_value_text
        ),
        sep = "\n"
    )
    invisible(x)
}

# Misc methods for object abbrievation -----------------------------------------

wrap_str <- function(x) {
    x_width <- max(crayon::col_nchar(x))
    x <- snip_str(x)
    crayon::col_align(x, width = x_width, align = "left", type = "width")
}

snip_str <- function(x) {
    x_width <- max(crayon::col_nchar(x))
    x_long <- crayon::col_nchar(x) > 30
    x[x_long] <- paste0(crayon::col_substring(x[x_long], 1, 30), "\U2026")
    x
}

condense_object <- function(x) {
    if (inherits(x, "data.frame")) {
        x_dim <- dim(x)
        crayon::style(
            sprintf(
                "<%s \u00d7 %s>",
                x_dim[1],
                x_dim[2]
            ),
            "grey60"
        )
    } else if ((is.vector(x) || is.factor(x)) && length(x) > 3) {
        crayon::style(
            sprintf("%s obs", length(x)),
            "grey60"
        )
    } else if (inherits(x, "enum")) {
        obj_len <- length(x)
        pl <- if (obj_len > 1 || obj_len < 1) "members" else "member"
        crayon::style(
            sprintf("%s %s", length.enum(x), pl),
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
        x_class
    )
}

equalise_widths <- function(x, .width) {
    return(formatC(x, width = -.width))
}