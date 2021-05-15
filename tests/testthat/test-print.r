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

        # Print all types in class abbr
        print(
            enum(
                a = TRUE, # logical
                b = 5, #numeric
                c = "str", #string
                d = 5i, #complex
                e = raw(1), #raw
                f = list(), #list
                g = NULL,
                # h = closureofsomekind
                #i =
                j = environment(),
                # k = S4
                l = substitute(x), # symbol,
                m = pairlist(1), #pairlist
                # n = delayedAssign("x", 5), #promise
                o = substitute(x + y),
                p = expression(x + y),
                q = mtcars,
                r = matrix(),
                s = array(1),
                t = formula(~ x + y),
                u = factor(),
                v = mean,
                x = enum()
            )
        )

        print(
            enum(
                a = enum()
            )
        )

        print(
            enum(
                a = enum(a)
            )
        )
    })
})
