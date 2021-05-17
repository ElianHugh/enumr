#' Enum constructors
#'
#' @description
#'  * `new_numeric_enum()` creates and validates a
#'  numeric enum from a named list of arguments
#'  * `new_generic_enum()` creates and validates a
#'  generic enum from a named list of arguments
#' @param .enum_data named list of arguments
#' @seealso [enum()], [as_enum()]
#' @examples
#' new_numeric_enum(list(x = 5, y = 2))
#'
#' new_generic_enum(list(x = mtcars, y = "string"))
#' @name new_enum
NULL

#' @export
#' @rdname new_enum
new_numeric_enum <- function(.enum_data) {
    supply_names_and_values <- function(dat, index, obj) {
        if (is.symbol(dat) && rlang::names2(obj[index]) == "") {
            dat_name <- rlang::as_name(dat)
            if (index > 1L && .check_eval(index - 1L, .enum_data)) {
                value <- masked_eval(.enum_data[[index - 1L]], .enum_data) + 1L
            } else {
                value <- index
            }
            .enum_data[[index]] <<- value
            names(.enum_data)[index] <<- dat_name
        } else if (is.language(dat)) {
            .enum_data[[index]] <<- masked_eval(.enum_data[[index]], .enum_data)
        }
    }

    validate_enum_definition(.enum_data)

    mapply(
        function(x, y) supply_names_and_values(x, y, .enum_data),
        .enum_data,
        seq_along(.enum_data),
        SIMPLIFY = FALSE,
        USE.NAMES = FALSE
    )

    # Check if the generated values are unique too
    validate_numeric_enum(.enum_data)

    enum_env <- new.env()
    enum_env$enum <- .enum_data
    class(enum_env) <- c("numeric_enum", "enum")
    lockEnvironment(enum_env, bindings = TRUE)
    enum_env
}

#' @export
#' @rdname new_enum
new_generic_enum <- function(.enum_data) {
    evaluate_symbols <- function(dat, index) {
        if (is.symbol(dat) || is.language(dat)) {
            .enum_data[[index]] <<- masked_eval(.enum_data[[index]], .enum_data)
        }
    }

    validate_enum_definition(.enum_data)

    # evaluate any symbols in supplied data
    mapply(
        function(x, y) evaluate_symbols(x, y),
        .enum_data,
        seq_along(.enum_data),
        SIMPLIFY = FALSE,
        USE.NAMES = FALSE
    )

    validate_generic_enum(.enum_data)

    enum_env <- new.env()
    enum_env$enum <- .enum_data
    class(enum_env) <- c("generic_enum", "enum")
    lockEnvironment(enum_env, bindings = TRUE)
    enum_env
}

#' Enum Validator
#' @description
#' `validate_enum_definition()` checks the enum arguments
#' for validity
#' @param .enum_data named list of arguments
#' @rdname validate_enum
#' @export
validate_enum_definition <- function(.enum_data) {
    #' @section Validation:
    #' `validate_enum_definition()` checks that all values supplied have names.
    if (any(.only_values_supplied(.enum_data))) {
        error_need_named_args()
    }
    invisible(.enum_data)
}

#' @description
#' `validate_numeric_enum()` checks named list of arguments
#' for validity
#' @rdname validate_enum
#' @export
validate_numeric_enum <- function(.enum_data) {
    is_numeric_value <- lapply(
        .enum_data,
        is.numeric
    )

    #' @section Validation:
    #' `validate_numeric_enum()` checks that, when evaluated,
    #' all the enum members are unique,
        if (anyDuplicated.default(unlist(.enum_data, use.names = FALSE)) ||
            anyDuplicated.default(names(.enum_data))) {
            error_unique()
        }

    #' and can be interpreted as numeric
    if (any(is_numeric_value == FALSE)) {
        error_interpret_as_numeric()
    }

    invisible(.enum_data)
}

#' @description
#' `validate_generic_enum()` checks generic enums
#' for validity
#' @rdname validate_enum
#' @export
validate_generic_enum <- function(.enum_data) {
    #' @section Validation:
    #' `validate_generic_enum()` check that all
    #' arguments supplied to the constructor
    #' have a name and value.
    if (any(rlang::names2(.enum_data) == "")) {
        error_explicit_definition()
    }

    if (anyDuplicated.default((.enum_data)) ||
        anyDuplicated.default(names(.enum_data))) {
        error_unique()
    }

    invisible(.enum_data)
}

.is_numeric_enum <- function(.enum_data) {
    if (is.null(names(.enum_data))) {
        return(TRUE)
    } else {
        checked_vals <- all(
            unlist(
                lapply(seq_along(.enum_data), .check_eval, .enum_data),
                use.names = FALSE,
                recursive = FALSE
            )
        )
        return(checked_vals)
    }
}

# Check that the enum has atomic members without names
# Returns TRUE if this is the case, which will cause
# enumr to shoot an error
.only_values_supplied <- function(obj) {
    for (i in seq_along(obj)) {
        if ((is.atomic(obj[[i]]) || is.call(obj[[i]])) &&
            any(rlang::names2(obj[i]) == "")) {
            return(TRUE)
        } else {
            next
        }
    }
}