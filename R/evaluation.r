.check_eval <- function(index, obj) {
    obj_val <- obj[[index]]

    if (is.character(obj_val) || is.list(obj_val)) {
        return(FALSE)
    } else if (is.numeric(obj_val)) {
        return(TRUE)
    } else if (is.symbol(obj_val)) {
        sym_name <- rlang::names2(obj[index])
        return(any(sym_name == ""))
    }

    # * TODO should be a more elegant and futureproof way of doing this
    # hardcoded this way because it's more performant than
    # getting all operators through a function,
    math_ops <- c(
        "+", "-", "*", "^", "%%", "%/%", "/", "==", ">", "<", "!=",
        "<=", ">=", "abs", "sign", "sqrt", "ceiling", "floor", "trunc",
        "cummax", "cummin", "cumprod", "cumsum", "exp", "expm1", "log",
        "log10", "log2", "log1p", "cos", "cosh", "sin", "sinh", "tan",
        "tanh", "acos", "acosh", "asin", "asinh", "atan", "atanh", "cospi",
        "sinpi", "tanpi", "gamma", "lgamma", "digamma", "trigamma"
    )

    if (any(all.names(obj_val, unique = TRUE) %in% math_ops)) {
        return(TRUE)
    } else {
        return(
            is.numeric(
                masked_eval(
                    obj_val,
                    obj,
                    eval_env = parent.frame(5L)
                )
        ))
    }
}

# eval_env is generally set to some level of parent.frame,
# so as to get the constructor's calling environment
masked_eval <- function(.x, .enum_data, env = rlang::caller_env(),
                                            eval_env = .GlobalEnv) {
    enum_call <- rlang::expr(!!.x)
    enum_data_mask <- rlang::new_data_mask(
        rlang::env(env, `.` = .enum_data)
    )

    tryCatch(
        expr = {
            rlang::eval_tidy(enum_call, enum_data_mask, eval_env)
        },
        error = function(e) {
            error_cannot_evaluate(e)
        }
    )
}
