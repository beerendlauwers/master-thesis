> instance Show (x -> a)
> instance Eq (x -> a)

> instance (Num a,Eq a) => Num (x -> a) where
>     fromInteger = const . fromInteger
>     f + g = \x -> f x + g x
>     f * g = \x -> f x * g x
>     negate = (negate .)
>     abs = (abs .)
>     signum = (signum .)

    coreturn :: w a -> a
    cobind :: (w a -> b) -> w a -> w b

> class Functor w => Comonad w where
>   extract :: w a -> a
>   duplicate :: w a -> w(w a)
>   duplicate = extend id
>   extend :: (w a -> g) -> w a -> w g
>   extend f x = fmap f (duplicate x)

> instance Comonad [] where
>     extract (x:xs) = x
>     extend f [] = []
>     extend f (x:xs) = f (x:xs) : extend f xs

-- cfix [2*head.tail,1+head.tail,17] : cfix [1+head.tail,17 :nhhh: []

> cfix :: Comonad d => d (d a -> a) -> a
> cfix d = extract d (extend cfix d)

> ouroboros = [2*head.tail,1+head.tail,17]
> test = cfix ouroboros

> test2 = extract ouroboros

> loeb :: Functor a => a (a x -> x) -> a x
> loeb x = fmap (\a -> a (loeb x)) x

testloeb = loeb ouroboros

> testdap = cfix [4*head.tail,1+head.tail,17]

> step1 = cfix [2*head.tail,1+head.tail,17]
> step2 = extract [2*head.tail,1+head.tail,17] (extend cfix [2*head.tail,1+head.tail,17])
> step3 = (2*head.tail) (extend cfix [2*head.tail,1+head.tail,17])
> step4 = (2*head.tail) (cfix [2*head.tail,1+head.tail,17] : cfix [1+head.tail,17] : cfix [17] : cfix [])
> step5 = (2) * (cfix [1+head.tail,17])
> step6 = (2) * ( extract [1+head.tail,17] (extend cfix [1+head.tail,17]) )
> step7 = (2) * ( (1+head.tail) (extend cfix [1+head.tail,17]) )
> step8 = (2) * ( (1+head.tail) (cfix [1+head.tail,17] : cfix [17] : cfix []) )
> step9 = (2) * ( (1+) (cfix [17]) )
> step10 = 2 * ( 1 + (extract [17] (extend cfix [17])) )
> step11 = 2 * ( 1 + ( 17 ( cfix [17] : cfix [] ) ) )
> step12 = 2 * ( 1 + ( 17 ) )

> testex =  extract ouroboros (cfix [2*head.tail,1+head.tail,17] : cfix [1+head.tail,17] : cfix [17] : cfix [])
> testex15 = (2*head.tail) (cfix [2*head.tail,1+head.tail,17] : cfix [1+head.tail,17] : cfix [17] : cfix [])

> testex16 = (2) * (cfix [1+head.tail,17])

> testdapsap = (head) ( cfix [1+head.tail,17] : cfix [17] : cfix [])

> testex2 = extract ouroboros ( extract [2*head.tail,1+head.tail,17] (cfix [2*head.tail,1+head.tail,17] : cfix [1+head.tail,17] : cfix []) : cfix [1+head.tail,17] : cfix [])


phone = a -> Store (p -> a) (p a)