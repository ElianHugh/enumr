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
      # A generic enum: 22 members
       lgl   a  : NULL
       num   b  : NULL
       chr   c  : NULL
       cpl   d  : NULL
       raw   e  : NULL
       list  f  : NULL
       list  g  : NULL
       env   j  : NULL
       sym   l  : NULL
       plist m  : NULL
       lang  o  : NULL
       expr  p  : NULL
       df    q  : NULL
       mtrx  r  : NULL
       arr   s  : NULL
       form  t  : NULL
       fct   u  : NULL
       fn    v  : NULL
       enum  x  : NULL
       enum  z  : NULL
       NULL  aa : NULL
       lang  ab : base::quote(x + y)
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

