test_that("s3 methods work", {
    a <- enum(a = 1, b = 2, c = 3)
    expect_identical(a[[1]], 1)
    expect_identical(a$a, a[[1]])
    expect_identical(length(a), 3L)
    expect_identical(names(a), c("a", "b", "c"))
})
