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