test_that("numeric enums can be created with NSE", {
    expect_error((enum(a = .$c + 10, b = .$a + 1, c = 50)), NA)
    a <- enum(a, b = sqrt(500), c = 5, d = .$b * .$c)
    expect_true(a$d == (sqrt(500) * 5))
})

test_that("generic enums can be created with NSE", {
    expect_error((enum(a = "Hello", b = c(.$a, "world!"))), NA)
    a <- enum(a = "Hello", b = c(.$a, "world!"))
    expect_true(any(a$b == c("Hello", "world!")))
})

test_that("numeric enum should work even if values are not supplied", {
    a <- enum(a, b = .$a + 5, c)
    expect_true(a$c == 7)
})
