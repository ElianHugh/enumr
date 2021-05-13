test_that("coercion to enums is functional", {
    # List coercion
    y <- list(a = 1, b = 2, c = 3)
    expect_identical(
        as.list(as_enum(y)),
        as.list(enum(a = 1, b = 2, c = 3))
    )

    # Env coercion
    x <- rlang::env(
        a = 5,
        b = mtcars,
        c = "str"
    )
    expect_identical(
        as.list(as_enum(x)),
        as.list(enum(a = 5, b = mtcars, c = "str"))
    )

    # Factor coercion
    z <- factor(c("blue", "red", "green"))
    expect_identical(
        as.list(as_enum(z)),
        as.list(enum(blue = 1, green = 2, red = 3))
    )

})
