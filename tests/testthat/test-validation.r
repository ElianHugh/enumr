test_that("enum definition validation works", {
    # No values
    expect_error(
        validate_enum_definition(list(1, a = 3)),
        class = "enumr-definition-error"
    )
})

test_that("numeric validation works", {
    # Expect unique evaluated values
    expect_error(
        new_numeric_enum(list(a = 1, b = substitute(2 - 1))),
        class = "enumr-definition-error"
    )
    # Can be coerced to numeric
    expect_error(
        validate_numeric_enum(list(a = 1, b = substitute("str"))),
        class = "enumr-definition-error"
    )
    # No duplicate names
    expect_error(
        validate_numeric_enum(list(a = 1, a = 5)),
        class = "enumr-definition-error"
    )
})

test_that("generic validation works", {
    # Expect named members
    expect_error(
        validate_generic_enum(list(a = "str", substitute(b))),
        class = "enumr-definition-error"
    )
    # No duplicate names
    expect_error(
        validate_generic_enum(list(a = "str", a = 5)),,
        class = "enumr-definition-error"
    )

    expect_error(
        validate_generic_enum(list(a = 1, b = 1)),
        class = "enumr-definition-error"
    )
})

test_that("masked eval throws correct error", {
    expect_error(
        masked_eval(substitute(x + y), NULL),
        class = "enumr-evaluation-error"
    )
})
