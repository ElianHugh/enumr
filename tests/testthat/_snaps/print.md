# snapshot is accurate

    Code
      print(enum(a, b, c))
    Output
      # A numeric enum: 3 members
       num a : 1
       num b : 2
       num c : 3
    Code
      print(long_enum)
    Output
      # A generic enum: 20 members
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
       enum  z : 1 member
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

