construct_error <- function(x) {
    paste0("enumr-", x, "-error")
}

# Definition errors ---------------------------------------

error_unique <- function() {
    error <- construct_error("definition")
    rlang::abort(
        c(
            "Incorrect arguments supplied to enum.",
            "Each argument name and value must be unique."
        ),
        class = error
    )
}

error_interpret_as_numeric <- function() {
    error <- construct_error("definition")
    rlang::abort(
        c(
            "Incorrect arguments supplied to enum.",
            "Each argument value must be interpretable as numeric."
        ),
        class = error
    )
}

error_explicit_definition <- function() {
    error <- construct_error("definition")
    rlang::abort(
        c(
            "Incorrect arguments supplied.",
            "All generic enum members must be initialised."
        ),
        class = error
    )
}

error_need_named_args <- function() {
    error <- construct_error("definition")
    rlang::abort(
        c(
            "Incorrect arguments supplied to enum.",
            "Each member must be named."
        ),
        class = error
    )
}

# Other errors -------------------------------------

error_illegal_assignment <- function() {
    error <- construct_error("assignment")
    rlang::abort(
        c(
            "Enum members cannot be assigned to after their definition",
            "Consider coercing to a list."
        ),
        class = error
    )
}

error_cannot_evaluate <- function(e) {
    error <- construct_error("evaluation")
    rlang::abort(
        c(
            "Argument cannot be evaluated",
            deparse(e[["message"]])
        ),
        class = error
    )
}

error_impossible_coercion <- function(x) {
    error <- construct_error("coercion")
    rlang::abort(
        sprintf(
            "Cannot coerce class `%s` to an enum",
            class(x)
        ),
        class = error
    )
}

error_invalid_args <- function() {
    error <- construct_error("argument")
    rlang::abort(
        sprintf(
            "Impossible to call method with given arguments:\n `%s`",
            deparse(sys.call(-1))
        ),
        class = error
    )
}