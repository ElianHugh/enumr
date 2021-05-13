test_that("print returns invisibly", {
    expect_output(ret <- withVisible(print(enum(a, b, c))))
    expect_false(ret$visible)
    expect_identical(as.list(ret$value), as.list(enum(a, b, c)))
})
