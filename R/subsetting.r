#' Subsetting enums
#'
#' @description
#'
#' Access enum members through subsetting with numeric or character indices.
#'
#' Enums are converted to a list type through the
#' [`as.list`]][base::as.list()] method, before being subset by an index.
#'
#' @details
#'
#' Enums are not intended to be used as interactive data structures.
#' Assigning to enum members is not supported, and will
#' throw an error if attempted.
#'
#' If you require an enum to be modifiable, consider using a
#' [`list`][base::list()] instead.
#'
#' @param x enum to subset
#' @param arg value to subset enum with, generally the indices of the enum
#' @param value assigning values to enums is not allowed
#' @name subsetting
#' @examples
#' a <- enum(a,b,c)
#' a[1]
#' a[[1]]
#' a$a
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
    error_illegal_assignment()
}

#' @export
#' @rdname subsetting
`[<-.enum` <- `$<-.enum`

#' @export
#' @rdname subsetting
`[[<-.enum` <- `$<-.enum`
