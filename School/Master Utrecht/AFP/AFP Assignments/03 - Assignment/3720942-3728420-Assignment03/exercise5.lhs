%include lhs2TeX.fmt
We'll use this function to generate exponential amounts of type variables:

> func2 a b c d e f g = (a,b,c,d,e,f,g)

By applying func2 to itself, we generate $(7^2) - 1$ type variables. Applying the resulting function to func2 again results in $(7^3) - 1$ type variables.
This way, we can easily generate an expression with an exponential amount of type variables.

sf generates $7^{n+1} - 1$ type variables.

> sf1 = func2 func2 func2 func2 func2 func2 func2 func2 -- 48 type variables
> sf2 = func2 sf1 sf1 sf1 sf1 sf1 sf1 sf1 -- 342 type variables
> sf3 = func2 sf2 sf2 sf2 sf2 sf2 sf2 sf2 -- 2400 different type variables
> sf4 = func2 sf3 sf3 sf3 sf3 sf3 sf3 sf3 -- 16806 different type variables

< sf5 = func2 sf4 sf4 sf4 sf4 sf4 sf4 sf4 -- 117648 different type variables
< sf6 = func2 sf5 sf5 sf5 sf5 sf5 sf5 sf5 -- 823542 different type variables
< sf7 = func2 sf6 sf6 sf6 sf6 sf6 sf6 sf6 -- 5764800 different type variables
< sf8 = func2 sf7 sf7 sf7 sf7 sf7 sf7 sf7 -- 40353606 different type variables
< sf9 = func2 sf8 sf8 sf8 sf8 sf8 sf8 sf8 -- 282475248 different type variables,
<					  -- that should be enough.

Also, we have:

> func x = (x,x)

By composing | func | with itself, the tuple | (x,x) | expands to | ((x,x),(x,x)) |. 
Composing it again results in four tuples that in total contain eight | x |'s.
This way, an exponentional type signature can be generated trivially, but there is only a single type variable in the signature: | a |.
By applying this very long pointfree expression to one of the above functions, each | a | is expanded to a tuple that has a large amount of type variables.
The type variable generation is also exponential, so it can quickly enough overwhelm the type checker on its own.

> two = func . func
> four = two . two
> eight = four . four
> sixteen = eight . eight

< test = sixteen $ sf4
