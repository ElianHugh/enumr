#' Enumerator
#'
#' Define an enumerator to access values from. Values cannot be reassigned.
#' Values can be anything (within reason).
#'
#' @details
#' Enums defined without initialisers are considered numeric enums, and have
#' their values set to incrementing numbers. Numeric enums can also be a mix of
#' defined numeric values and undefined members.
#'
#' Under the surface, enums are actually lists contained within locked environments.
#' This is so that the enum bindings cannot be modified, and the enum order is maintained.
#' S3 methods are defined for `$`, `[`, and `[[`, which access the enum list directly.
#' @param ... list of enumerator arguments
#'
#' @return enum class environment, can be used as a list
#' @examples
#' fruits <- enum(apple = "apple", pear = "pear")
#' errors <- enum(style, warning, error)
#' data <- enum(dat1 = mtcars, dat2 = iris, dat3 = PlantGrowth)
#' mixed_enum <- enum(a = 5, b = mtcars, c = 50, d = "elephant")
#' computed_enum <- enum(a = 50, b = .$a * 2)
#' @export
#' @seealso \code{\link[base]{environment}}, \code{\link[base]{list}}
enum <- function(...) {
    capture <- rlang::enexprs(...)

    if (missing(...)) {
        rlang::abort(
            "Must supply arguments to enum definition.",
        )
    }

    if (length(capture) != length(unique.default(capture))) {
        rlang::abort(
            "Incorrect arguments supplied to enum. Each enum member must be unique."
        )
    }

    if (any(
        mapply(
            function(x, y) only_values_supplied(
                dat = x,
                index = y,
                obj = capture
                ),
            x = capture,
            y = seq_along(capture),
            USE.NAMES = FALSE
        )
    )) {
        rlang::abort(
            "Incorrect arguments supplied to enum. Each member must be named."
        )
    }

    # check is numeric enum
    if (is_numeric_enum(capture)) {
        create_numeric_enum(capture)
    } else {
        create_generic_enum(capture)
    }
}

create_numeric_enum <- function(.data) {
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

    mapply(
        function(x, y) supply_names_and_values(x, y, .data),
        .data,
        seq_along(.data),
        SIMPLIFY = FALSE,
        USE.NAMES = FALSE
    )

    coerced_vals <- lapply(
        seq_along(.data),
        function(x) {
            x <- as.numeric(
                masked_eval(.data[[x]], .data)
            )
            return(x)
        }
    )

    # Check if the generated values are unique too
    if ((length(coerced_vals) != length(unique.default(coerced_vals)))) {
        rlang::abort(
            "Incorrect arguments supplied to enum. Each argument value must be unique."
        )
    }

    enum_env <- rlang::new_environment(data = list(enum = .data))
    class(enum_env) <- c("numeric_enum", "enum", "environment")
    lockEnvironment(enum_env, bindings = TRUE)
    enum_env
}

create_generic_enum <- function(.data) {
    if (any(rlang::names2(.data) == "")) {
        rlang::abort(
            "Incorrect arguments supplied. All generic enum members must be initialised."
        )
    }

    evaluate_symbols <- function(dat, index) {
        if (is.symbol(dat) || is.language(dat)) {
            .data[[index]] <<- masked_eval(.data[[index]], .data)
        }
    }

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
