test_that("coercing from enums work as expected", {
    x <- enum(a, b, c, d)

    expect_identical(
        as.list.enum(x),
        list(a = 1L, b = 2L, c = 3L, d = 4L)
    )

    expect_identical(
        as.character.enum(x),
        c("1", "2", "3", "4")
    )

    expect_identical(
        as.numeric.enum(x),
        c(1, 2, 3, 4)
    )

    expect_identical(
        as.data.frame.enum(x),
        data.frame(
            row.names = c("a", "b", "c", "d"),
            values = c(1L, 2L, 3L, 4L)
        )
    )
})