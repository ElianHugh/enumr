test_that("enum definition validation works", {
    # Expect unique values
    ## values
    expect_error(
        validate_enum_definition(list(a = 1, b = 1)),
        class = "enumr_definition_error"
    )

    # No values
    expect_error(
        validate_enum_definition(list(1, a = 3)),
        class = "enumr_definition_error"
    )
})

test_that("numeric validation works", {
    # Expect unique evaluated values
    expect_error(
        validate_numeric_enum(list(a = 1, b = substitute(2 - 1))),
        class = "enumr_numeric_definition_error"
    )
    # Can be coerced to numeric
    expect_error(
        validate_numeric_enum(list(a = 1, b = substitute("str"))),
        class = "enumr_numeric_definition_error"
    )
    # No duplicate names
    expect_error(
        validate_numeric_enum(list(a = 1, a = 5)),
        class = "enumr_numeric_definition_error"
    )
})

test_that("generic validation works", {
    # Expect named members
    expect_error(
        validate_generic_enum(list(a = "str", substitute(b))),
        class = "enumr_generic_definition_error"
    )
    # No duplicate names
    expect_error(
        validate_generic_enum(list(a = "str", a = 5)),
        class = "enumr_generic_definition_error"
    )
})
