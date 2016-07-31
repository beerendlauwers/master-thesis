%include lhs2TeX.fmt

> {-# LANGUAGE ScopedTypeVariables #-}
> module StackLanguage where
> data Result = AResult [Int] deriving Show

> store :: Result -> Int -> Result
> (AResult xs) `store` x = AResult (x:xs)


> mul :: Result -> (Result -> a) -> a
> mul (AResult (x:y:ys)) next = next $ AResult (x*y:ys)

> add :: Result -> (Result -> a) -> a
> add (AResult (x:y:ys)) next = next $ AResult (x+y:ys)

> stop = \(AResult xs) -> case xs of
>                              [] -> error "No Integer on stack available!"
>                              otherwise -> head xs

> r &> x = store r x
> l +> r = add l r
> l *> r = mul l r

> start = AResult []

> p1 = start `store` 3 `store` 5 `add` stop
> p2 = start `store` 3 `store` 6 `store` 2 `mul` add $ stop
> p3 = start `store` 2 `add` stop

> p1' = start &> 3 &> 5 +> stop
> p2' = start &> 3 &> 6 &> 2 *> (+> stop)
> p3' = start &> 2 +> stop