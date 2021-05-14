test_that("print returns invisibly", {
    expect_output(
        ret <- withVisible(
            print(
                enum(a = mtcars, b = mean, c = "test", d = list(1, 2, 3, 4, 5))
            )
        )
    )
    expect_false(ret$visible)
    expect_identical(
        as.list(ret$value),
        as.list(enum(a = mtcars, b = mean, c = "test", d = list(1, 2, 3, 4, 5)))
    )
})

test_that("snapshot is accurate", {
    expect_snapshot({
        print(enum(a, b, c))
        print(enum(a = "str", b = mtcars, c = 5i))
    })
})
