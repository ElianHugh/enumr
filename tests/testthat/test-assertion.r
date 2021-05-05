library(typed, warn.conflicts = FALSE)
test_that("Enum(x) assertion as function arg", {
    a <- enum(a = "str", b = 2)
    test_assertion <- ? function(x = ? Enum(a)) {}
    expect_error(test_assertion(5))
    expect_error(test_assertion("st"))
    expect_error(test_assertion(mtcars))

    # Allow!
    expect_error(test_assertion(2), NA)
    expect_error(test_assertion(a$a), NA)
    expect_error(test_assertion("str"), NA)
})

test_that("Enum() assertion as definition", {
    expect_error((Enum() ? a <- 5))

    expect_error((Enum() ? a), NA)
    expect_error((Enum() ? a <- enum(a, b, c)), NA)
})

test_that("Enum() assertion as function return", {
    invalid_function <- Enum() ? function() {}
    expect_error((invalid_function()))

    valid_function <- Enum() ? function() {
        enum(a, b, c)
    }
    expect_error(valid_function(), NA)
})