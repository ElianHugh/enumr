# General S3

test_that("general S3 methods are functioning", {
    a <- enum(a = 1, b = 2, c = 3)
    expect_identical(length(a), 3L)
    expect_identical(names(a), c("a", "b", "c"))
    expect_identical(as.character(a), as.character(list(a = 1, b = 2, c = 3)))
})

# Subsetting

test_that("enum members cannot be assigned to with subsetting", {
    a <- enum(a = 1, b = 2, c = 3)
    expect_error(
        a[1] <- 5,
        class = "enumr_deny_assign"
    )
    expect_error(
        a[[1]] <- 5,
        class = "enumr_deny_assign"
    )
    expect_error(
        a$a <- 5,
        class = "enumr_deny_assign"
    )
})

test_that("enums can be subset", {
    a <- enum(a = 1, b = 2, c = 3)
    expect_identical(a[1], list(a = 1))
    expect_identical(a[[1]], a$a)
})

test_that("str functions correctly", {
    a <- enum(a, b, c)
    expect_snapshot(a)
})
