test_that('enum construction functions properly', {
    # numeric enums
    expect_error((enum(a, b, c)), NA)
    expect_error((enum(a = 5, b, c = 3)), NA)
    expect_error((enum(a = 1 + 2, b, c)), NA)
    expect_error((enum(a, b = 5 * 2, c)), NA)

    # generic enums
    expect_error((enum(a = 5, b = mtcars, c = 3)), NA)
    expect_error((enum(a = "a", b = "b", c = "c")), NA)
    expect_error((enum(a = mtcars, b = airquality, c = PlantGrowth)), NA)
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

test_that("enum values are accessible", {
    a <- enum(item1 = 5, item2 = "test", item3 = mtcars)
    expect_equal(a[[1]], 5)
    expect_equal(a$item1, 5)

    expect_identical(a[[2]], "test")
    expect_identical(a$item2, "test")
    expect_identical(a[[3]], mtcars)
})

test_that("enum constructors are functional", {
    # Generic
    expect_error(new_generic_enum(list(x = mtcars, y = "chr")), NA)
    expect_error(new_generic_enum(list(x = mtcars, y = mtcars)))

    # Numeric
    expect_error(new_numeric_enum(list(x = 1, y = 2)), NA)
    expect_error(new_numeric_enum(list(x = "string")))
})
