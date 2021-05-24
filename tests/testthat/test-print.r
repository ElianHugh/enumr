long_enum <- enum(
    a = TRUE, # logical
    b = 5, # numeric
    c = "str", # string
    d = 5i, # complex
    e = raw(1), # raw
    f = list(), # list
    g = list(1,2,3,4),
    # h = closureofsomekind
    # i =
    j = environment(),
    # k = S4
    l = substitute(x), # symbol,
    m = pairlist(1), # pairlist
    # n = delayedAssign("x", 5), #promise
    o = substitute(x + y),
    p = expression(x + y),
    q = mtcars,
    r = matrix(),
    s = array(1),
    t = formula(~ x + y),
    u = factor(),
    v = mean,
    x = enum(),
    z = enum(a = "str"),
    aa = NULL,
    ab = enquote(substitute(x + y))
)

test_that("print returns invisibly", {
    expect_output(
        ret <- withVisible(
            print(
                long_enum
            )
        )
    )
    expect_false(ret$visible)
    expect_identical(
        as.list(ret$value),
        as.list(long_enum)
    )
})

test_that("snapshot is accurate", {
    skip_if_not(interactive())
    expect_snapshot({
        print(enum(a, b, c))

        # Print all types in class abbr
        print(
            long_enum
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
