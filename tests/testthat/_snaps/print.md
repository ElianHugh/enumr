# snapshot is accurate

    Code
      print(enum(a, b, c))
    Output
      # A numeric enum: 3 members
       num a : 1
       num b : 2
       num c : 3
    Code
      print(enum(a = "str", b = mtcars, c = 0+5i))
    Output
      # A generic enum: 3 members
       chr a : str
       df  b : <32 × 11>
       cpl c : 0+5i

