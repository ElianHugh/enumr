test_that('enum construction functions properly', {
    # numeric enums
    expect_error((enum(a, b, c)), NA)
    expect_error((enum(a = 1 + 2, b, c)), NA)
    expect_error((enum(a, b = 5 * 2, c)), NA)

    # generic enums
    expect_error((enum(a = 5, b = mtcars, c = 3)), NA)
    expect_error((enum(a = "a", b = "b", c = "c")), NA)
    expect_error((enum(a = environment())), NA)
})

test_that('invalid enums are disposed of', {
    # unnamed enums
    expect_error((enum("test", "tester")))

    # mixed enums
    expect_error((enum(b = "jet", c)))

    # numeric enums
    expect_error((enum(a, a)))
    expect_error((enum(a, b = 1)))
})

test_that("enum constructors are functional", {
    # Generic
    expect_error(new_generic_enum(list(x = mtcars, y = "chr")), NA)
    expect_error(new_generic_enum(list(x = mtcars, y = mtcars)))

    # Numeric
    expect_error(new_numeric_enum(list(x = 1, y = 2)), NA)
    expect_error(new_numeric_enum(list(x = "string")))
})

test_that("enum classes are assigned appropriately", {
    a <- enum(a, b, c)
    expect_true(inherits(a, "enum"))
    expect_true(inherits(a, "numeric_enum"))
    expect_false(inherits(a, "generic_enum"))

    b <- enum(a = "string", b = "string2")
    expect_true(inherits(b, "enum"))
    expect_true(inherits(b, "generic_enum"))
    expect_false(inherits(b, "numeric_enum"))
})

test_that("computed enums are numeric enums", {
    a <- enum(a, b = 2 + 2, c = .$b + 5)
    expect_true(inherits(a, "enum"))
    expect_true(inherits(a, "numeric_enum"))
})
