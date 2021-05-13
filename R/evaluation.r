.check_eval <- function(index, obj) {
    # if the obj is a symbol,
    # we have to *indirectly* check if
    # it has an accessible value.
    # if it is a symbol and does NOT
    # have a name, this means it is
    # an argument without a supplied value
    # e.g. a <- enum(a, b, c)
    #     vs. a <- enum(a = mtcars)
    # Ideally, we only want to allow
    # symbols that result in a number value
    obj_val <- obj[[index]]

    if (is.symbol(obj_val)) {
        sym_name <- rlang::names2(obj[index])
        return(any(sym_name == ""))
    }

    if (is.language(obj_val)) {
        if (is.environment(masked_eval(obj_val, obj_val))) {
            return(FALSE)
        } else {
            return(TRUE)
        }
    }

    # at this point, the object
    # is either a number, or directly
    # evaluates to a number
    eval_x <- masked_eval(obj_val, obj)
    return(is.numeric(eval_x))
}

masked_eval <- function(.x, .enum_data, env = rlang::caller_env()) {
    temp_env <- rlang::env(env, `.` = .enum_data)
    enum_call <- rlang::expr(!!.x)
    enum_data_mask <- rlang::new_data_mask(temp_env)
    tryCatch(
        expr = {
            rlang::eval_tidy(enum_call, enum_data_mask, .GlobalEnv)
        },
        error = function(e) {
            rlang::abort(
                c("Argument does not evaluate to a value", e[["call"]])
            )
        }
    )
}
