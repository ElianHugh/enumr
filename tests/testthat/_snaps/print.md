# snapshot is accurate

    Code
      print(enum(a, b, c))
    Output
      # A numeric enum: 3 members
       num a : 1
       num b : 2
       num c : 3
    Code
      print(enum(a = TRUE, b = 5, c = "str", d = 0+5i, e = raw(1), f = list(), g = NULL,
      j = environment(), l = substitute(x), m = pairlist(1), o = substitute(x + y),
      p = expression(x + y), q = mtcars, r = matrix(), s = array(1), t = formula(~x +
        y), u = factor(), v = mean, x = enum()))
    Output
      # A generic enum: 19 members
       lgl   a : TRUE
       num   b : 5
       chr   c : str
       cpl   d : 0+5i
       raw   e : as.raw(0x00)
       list  f : list()
       NULL  g : NULL
       env   j : <environment>
       sym   l : x
       plist m : pairlist(1)
       lang  o : x + y
       expr  p : expression(x + y)
       df    q : <32 × 11>
       mtrx  r : NA
       arr   s : 1
       form  t : ~x + y
       fct   u : integer(0)
       fn    v : function(x, ...)
       enum  x : 0 members
    Code
      print(enum(a = enum()))
    Output
      # A generic enum: 1 member
       enum a : 0 members
    Code
      print(enum(a = enum(a)))
    Output
      # A generic enum: 1 member
       enum a : 1 member

