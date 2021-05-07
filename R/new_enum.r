#' Enum Constructors
#' @description
#' `new_numeric_enum()` creates and validates a
#' numeric enum from a named list of arguments
#' @param .data named list of arguments
#' @rdname new_enum
#' @seealso [enum()]
#' @export
#' @examples
#' new_numeric_enum(list(x = 5))
new_numeric_enum <- function(.data) {
    supply_names_and_values <- function(dat, index, obj) {
        if (is.symbol(dat) && rlang::names2(obj[index]) == "") {
            dat_name <- rlang::as_name(dat)
            if (index > 1L && check_eval(index - 1L, .data) == TRUE) {
                value <- masked_eval(.data[[index - 1L]], .data) + 1L
            } else {
                value <- index
            }
            .data[[index]] <<- value
            names(.data)[index] <<- dat_name
        } else if (is.language(dat)) {
            .data[[index]] <<- masked_eval(.data[[index]], .data)
        }
    }

    validate_enum_definition(.data)

    mapply(
        function(x, y) supply_names_and_values(x, y, .data),
        .data,
        seq_along(.data),
        SIMPLIFY = FALSE,
        USE.NAMES = FALSE
    )

    # Check if the generated values are unique too
    validate_numeric_enum(.data)

    enum_env <- rlang::new_environment(data = list(enum = .data))
    class(enum_env) <- c("numeric_enum", "enum", "environment")
    lockEnvironment(enum_env, bindings = TRUE)
    enum_env
}

#' Enum Constructors
#' @description
#' `new_generic_enum()` creates and validates a
#' generic enum from a named list of arguments
#' @param .data named list of arguments
#' @rdname new_enum
#' @export
#' @examples
#' new_generic_enum(list(x = "str"))
new_generic_enum <- function(.data) {
    validate_enum_definition(.data)
    validate_generic_enum(.data)

    evaluate_symbols <- function(dat, index) {
        if (is.symbol(dat) || is.language(dat)) {
            .data[[index]] <<- masked_eval(.data[[index]], .data)
        }
    }

    # evaluate any symbols in supplied data
    mapply(
        function(x, y) evaluate_symbols(x, y),
        .data,
        seq_along(.data),
        SIMPLIFY = FALSE,
        USE.NAMES = FALSE
    )

    enum_env <- rlang::new_environment(data = list(enum = .data))
    class(enum_env) <- c("generic_enum", "enum", "environment")
    lockEnvironment(enum_env, bindings = TRUE)
    enum_env
}

#' Enum Validator
#' @description
#' `validate_enum_definition()` checks the enum arguments
#' for validity
#' @param .data named list of arguments
#' @rdname validate_enum
#' @export
validate_enum_definition <- function(.data) {
    #' @section Validation:
    #' `validate_enum_definition()` checks that the names
    #' and values supplied to the constructor are unique,
    if (length(.data) != length(unique.default(.data))) {
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
                    obj = .data
                )
            },
            x = .data,
            y = seq_along(.data),
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
    invisible(.data)
}

#' @description
#' `validate_numeric_enum()` checks named list of arguments
#' for validity
#' @rdname validate_enum
#' @export
validate_numeric_enum <- function(.data) {
    coerced_vals <- lapply(
        seq_along(.data),
        function(x) {
            x <- as.numeric(
                masked_eval(.data[[x]], .data)
            )
            return(x)
        }
    )

    #' @section Validation:
    #' `validate_numeric_enum()` checks that, when evaluated,
    #' all the enum values are unique.
    if ((length(coerced_vals) != length(unique.default(coerced_vals)))) {
        rlang::abort(
            c(
                "Incorrect arguments supplied to enum.",
                "Each argument value must be unique."
            ),
            class = "enumr_numeric_definition_error"
        )
    }
    invisible(.data)
}

#' @description
#' `validate_generic_enum()` checks generic enums
#' for validity
#' @rdname validate_enum
#' @export
validate_generic_enum <- function(.data) {
    #' @section Validation:
    #' `validate_generic_enum()` check that all
    #' arguments supplied to the constructor
    #' have a name and value.
    if (any(rlang::names2(.data) == "")) {
        rlang::abort(
            c(
                "Incorrect arguments supplied.",
                "All generic enum members must be initialised."
            ),
            class = "enumr_generic_definition_error"
        )
    }
    invisible(.data)
}