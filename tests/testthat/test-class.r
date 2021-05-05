test_that('enum classes are assigned appropriately', {
    a <- enum(a, b, c)
    expect_true(inherits(a, "enum"))
    expect_true(inherits(a, "numeric_enum"))
    expect_false(inherits(a, "generic_enum"))
    a <- enum(a, b = 5, c)
    expect_true(inherits(a, "enum"))
    expect_true(inherits(a, "numeric_enum"))
    expect_false(inherits(a, "generic_enum"))

    b <- enum(a = "string", b = "string2")
    expect_true(inherits(b, "enum"))
    expect_true(inherits(b, "generic_enum"))
    expect_false(inherits(b, "numeric_enum"))
    b <- enum(a = 1, b = mtcars)
    expect_true(inherits(b, "enum"))
    expect_true(inherits(b, "generic_enum"))
    expect_false(inherits(b, "numeric_enum"))
})

test_that('computed enums are numeric enums', {
    a <- enum(a, b = 2 + 2, c)
    expect_true(inherits(a, "enum"))
    expect_true(inherits(a, "numeric_enum"))

    a <- enum(a = 10 + 15, b = 2 + 2, c = 100 / 2)
    expect_true(inherits(a, "enum"))
    expect_true(inherits(a, "numeric_enum"))
})
