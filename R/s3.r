condense_object <- function(x) {
    if (inherits(x, "data.frame")) {
        pillar::style_subtle(
            glue::glue("<{pillar::dim_desc(x)}>")
        )
    } else {
        x
    }
}

#' Print object
#' @param x an object to print
#' @param ... further arguments passed to format
#' @export
#' @describeIn Print Object
print.enum <- function(x, ...) {
    cat(format.enum(x, ...), sep = "\n")
    invisible(x)
}

#' Format string
#' @export
#' @describeIn Print Object
format.enum <- function(x, ...) {
    enum_list <- as.list.enum(x, all.names = FALSE, sorted = FALSE)
    vals <- lapply(enum_list, condense_object)
    enum_names <- names(vals)
    types <- lapply(enum_list, pillar::type_sum)
    enum_type <- ifelse(any(class(x) == "numeric_enum"), "numeric", "generic")
    toReturn <- c(
        pillar::style_subtle(
                glue::glue("# A {enum_type} enum: {length(x)} members")
            ),
            glue::glue(
                "  {pillar::style_subtle(types)} {enum_names} : {vals[enum_names]}"
            )
    )
}

#' Length
#' @export
#' @describeIn S3 Methods
length.enum <- function(x) {
    length(as.list.enum(x))
}

#' Names
#' @export
#' @describeIn S3 Methods
names.enum <- function(x) {
    names(as.list.enum(x))
}

#' As List
#' @param x object to coerce to list
#' @param all.names copy all values or only those that do not begin with a dot
#' @param sorted should the list be sorted by names?
#' @param ... other args
#' @export
#' @describeIn S3 Methods
as.list.enum <- function(x, all.names = FALSE, sorted = FALSE, ...) {
     as.list.environment(x, all.names, sorted)$enum
}

#' Extract Parts of Enum
#' @description
#' Access parts of enum through numeric or character indices
#' @param x object to examine
#' @param arg indices to extract
#' @param value value
#' @export
#' @describeIn Extract Enum
`$<-.enum` <- function(x, arg, value) {
    rlang::abort(
        "Enum members cannot be assigned to after their definition",
        class = "enumr_deny_assign"
    )
}

#' @export
#' @describeIn Extract Enum
`[<-.enum` <- `$<-.enum`

#' @export
#' @describeIn Extract Enum
`[[<-.enum` <- `$<-.enum`

#' @export
#' @describeIn Extract Enum
`[.enum` <- function(x, arg) {
    as.list.enum(x)[arg]
}

#' @export
#' @describeIn Extract Enum
`[[.enum` <- function(x, arg) {
    as.list.enum(x)[[arg]]
}

#' @export
#' @describeIn Extract Enum
`$.enum` <- function(x, arg) {
    as.list.enum(x)[[arg]]
}

## Coercion
as.character.enum <- function(x, ...) {
    as.character(as.list.enum(x), ...)
}
as.complex.enum <- function(x, ...) {
    as.complex(as.list.enum(x), ...)
}
