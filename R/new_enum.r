#' Enum Constructors
#' @description
#' `new_numeric_enum()` creates and validates a
#' numeric enum from a named list of arguments
#' @param .enum_data named list of arguments
#' @rdname new_enum
#' @seealso [enum()]
#' @export
#' @examples
#' new_numeric_enum(list(x = 5))
new_numeric_enum <- function(.enum_data) {
    supply_names_and_values <- function(dat, index, obj) {
        if (is.symbol(dat) && rlang::names2(obj[index]) == "") {
            dat_name <- rlang::as_name(dat)
            if (index > 1L && check_eval(index - 1L, .enum_data) == TRUE) {
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

    enum_env <- rlang::new_environment(data = list(enum = .enum_data))
    class(enum_env) <- c("numeric_enum", "enum")
    lockEnvironment(enum_env, bindings = TRUE)
    enum_env
}

#' Enum Constructors
#' @description
#' `new_generic_enum()` creates and validates a
#' generic enum from a named list of arguments
#' @param .enum_data named list of arguments
#' @rdname new_enum
#' @export
#' @examples
#' new_generic_enum(list(x = "str", y = mtcars))
new_generic_enum <- function(.enum_data) {
    validate_enum_definition(.enum_data)
    validate_generic_enum(.enum_data)

    evaluate_symbols <- function(dat, index) {
        if (is.symbol(dat) || is.language(dat)) {
            .enum_data[[index]] <<- masked_eval(.enum_data[[index]], .enum_data)
        }
    }

    # evaluate any symbols in supplied data
    mapply(
        function(x, y) evaluate_symbols(x, y),
        .enum_data,
        seq_along(.enum_data),
        SIMPLIFY = FALSE,
        USE.NAMES = FALSE
    )

    enum_env <- rlang::new_environment(data = list(enum = .enum_data))
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
    #' `validate_enum_definition()` checks that the names
    #' and values supplied to the constructor are unique,
    if (length(.enum_data) != length(unique.default(.enum_data))) {
        rlang::abort(
            c(
                "Incorrect arguments supplied to enum",
                "Each enum member must be unique."
            ),
            class = "enumr_definition_error"
        )
    }

    #' and ensures that all values supplied have names.
    if (any(
        mapply(
            function(x, y) {
                only_values_supplied(
                    dat = x,
                    index = y,
                    obj = .enum_data
                )
            },
            x = .enum_data,
            y = seq_along(.enum_data),
            USE.NAMES = FALSE
        )
    )) {
        rlang::abort(
            c(
                "Incorrect arguments supplied to enum.",
                "Each member must be named."
            ),
            class = "enumr_definition_error"
        )
    }
    invisible(.enum_data)
}

#' @description
#' `validate_numeric_enum()` checks named list of arguments
#' for validity
#' @rdname validate_enum
#' @export
validate_numeric_enum <- function(.enum_data) {
    coerced_vals <- lapply(
        seq_along(.enum_data),
        function(x) {
            suppressWarnings(
                x <- as.numeric(
                    masked_eval(.enum_data[[x]], .enum_data)
                )
            )
            return(x)
        }
    )

    #' @section Validation:
    #' `validate_numeric_enum()` checks that, when evaluated,
    #' all the enum values are unique
    if ((length(coerced_vals) != length(unique.default(coerced_vals)))) {
        rlang::abort(
            c(
                "Incorrect arguments supplied to enum.",
                "Each argument value must be unique."
            ),
            class = "enumr_numeric_definition_error"
        )
    }

    #' and can be interpreted as numeric
    if (anyNA(coerced_vals)) {
        rlang::abort(
            c(
                "Incorrect arguments supplied to enum.",
                "Each argument value must be interpretable as numeric."
            ),
            class = "enumr_numeric_definition_error"
        )
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
        rlang::abort(
            c(
                "Incorrect arguments supplied.",
                "All generic enum members must be initialised."
            ),
            class = "enumr_generic_definition_error"
        )
    }
    invisible(.enum_data)
}

is_numeric_enum <- function(.enum_data) {
    supplied_names <- names(.enum_data)
    checked_vals <- all(
        unlist(
            lapply(seq_along(.enum_data), check_eval, .enum_data),
            use.names = FALSE
        )
    )

    # if the supplied names are null, this means the
    # enum is constructed as enum(a, b, c...)
    # and is therefore numeric
    return(is.null(supplied_names) || checked_vals)
}

# ensures that enums cannot be constructed
# without names
only_values_supplied <- function(dat, index, obj) {
    return(is.atomic(dat) && any(rlang::names2(obj[index]) == ""))
}