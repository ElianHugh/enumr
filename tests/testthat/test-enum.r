test_that('valid enums can be created', {
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

test_that('invalid enums are stopped', {
    # unnamed enums
    expect_error((enum("test", "tester")))
    expect_error((enum(1, 2, 3)))
    expect_error((enum("test", 2)))

    # mixed enums
    expect_error((enum(b = "jet", c)))
    expect_error((enum(a = mtcars, b)))

    # numeric enums
    expect_error((enum(a, a)))
    expect_error((enum(a, b = 1)))
    expect_error((enum(a = 1, b, c = 1)))
    expect_error((enum(a = 1, b = 1 - 1, c)))
})

test_that("enum values are accessible", {
    a <- enum(item1 = 5, item2 = "test", item3 = mtcars)
    expect_equal(a[[1]], 5)
    expect_equal(a$item1, 5)
    expect_equal(a[1][[1]], 5)

    expect_identical(a[[2]], "test")
    expect_identical(a$item2, "test")
    expect_identical(a[2][[1]], "test")

    expect_identical(a[[3]], mtcars)
})