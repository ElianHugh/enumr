#' Subsetting enums
#' @description
#' Access enum members through subsetting with numeric or character indices
#' @details
#' Assigning to enum members is not supported, and will
#' throw an error if attempted.
#' @param x enum to subset
#' @param arg value to subset enum with, generally the indices of the enum
#' @param value assigning values to enums is not allowed
#' @name subsetting
NULL

#' @export
#' @rdname subsetting
`[.enum` <- function(x, arg) {
    as.list.enum(x)[arg]
}

#' @export
#' @rdname subsetting
`[[.enum` <- function(x, arg) {
    as.list.enum(x)[[arg]]
}

#' @export
#' @rdname subsetting
`$.enum` <- function(x, arg) {
    as.list.enum(x)[[arg]]
}

#' @export
#' @rdname subsetting
`$<-.enum` <- function(x, arg, value) {
    rlang::abort(
        "Enum members cannot be assigned to after their definition",
        class = "enumr_deny_assign"
    )
}

#' @export
#' @rdname subsetting
`[<-.enum` <- `$<-.enum`

#' @export
#' @rdname subsetting
`[[<-.enum` <- `$<-.enum`
