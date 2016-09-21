> module Assignment.TypeAB where
>
> -- | A type, as defined in the assingment specification.
> type A r a = (r, a -> r -> r)
> 
> -- | Example of application of an A type.
> getA :: A r a -> a -> r
> getA (r, f) a = f a r
>
> -- | B type, as defined in the assignment specification.
> type B r a = Maybe (a,r) -> r
>
> -- | Example of application of a B function.
> getB :: B r a -> Maybe (a,r) -> r
> getB f a = f a
> 
> -- | Converts a B type to an A type.
> g :: B r a -> A r a
> g x = (x Nothing, (\a r -> x (Just (a, r))))
> 
> -- | Converts an A type to a B type.
> f :: A r a -> B r a
> f (x, y) = (\z -> case z of
>               Nothing -> x
>               Just (a, r) -> y a r)
>
> -- | Function for the A test.
> funcA :: Int -> Integer -> Integer
> funcA x y = fromIntegral x + y
>
> -- | Sample A type:
> sampleA :: A Integer Int
> sampleA = (5, funcA)
>
> -- | Sample B type:
> sampleB :: B Integer Int
> sampleB Nothing       = 5
> sampleB (Just (a, r)) = fromIntegral a + r

Formal proof:

(1) forall (x :: B r a) (y :: Maybe (a,r)) : f (g x) y = x y

Take an arbitrary x such that x :: B r a.

Case y = Nothing

f (g x) Nothing = x Nothing
= {def. g}
f ( (x Nothing, (\a r -> x (Just (a,r)))) ) Nothing = x Nothing
= {def. f}
x Nothing = x Nothing

Case y = (Just (a,r))

f (g x) (Just (a,r)) = x (Just (a,r))
= {def. g}
f ( (x Nothing, (\a r -> x (Just (a,r)))) ) (Just (a,r)) = x (Just (a,r))
= {def. f}
(\a r -> x (Just (a,r))) a r = x (Just (a,r))
= {eta-reduction}
x (Just (a,r)) = x (Just (a,r))

Because x was arbitrary, this holds for all x.

(2) forall (x :: A r a) (y :: Maybe (a,r)) : g (f x) y = x y

Take an arbitrary x such that x :: A r a.

Case y = Nothing

g (f (r, (\a r -> r)) ) Nothing = (r, (\a r -> r)) Nothing
= {def. f}
g (r) = (r, (\a r -> r)) Nothing
= {def. g}
(r Nothing, (\a r -> r (Just (a,r)))) = (r, (\a r -> r)) Nothing
= {introduce function f}
f (r Nothing, (\a r -> r (Just (a,r)))) = f (r, (\a r -> r)) Nothing
= {def. f}
f (r Nothing, (\a r -> r (Just (a,r)))) = r
= {introduce (Just (a,r))}
f (r Nothing, (\a r -> r (Just (a,r)))) (Just (a,r)) = r (Just (a,r))
= {def. f}
(\a r -> r (Just (a,r))) a r = r (Just (a,r))
= {eta-reduction}
r (Just (a,r)) = r (Just (a,r))

Case y = (Just (a,r))

g (f (r, (\a r -> r)) ) (Just (a,r)) = (r, (\a r -> r)) (Just (a,r))
= {def. f}
g ( (\a r -> r) a r ) = (r, (\a r -> r)) (Just (a,r))
= {eta-reduction}
g (r) = (r, (\a r -> r)) (Just (a,r))
= {def. g}
(r Nothing, (\a r -> r (Just (a,r)))) = (r, (\a r -> r)) (Just (a,r))
= {introduce function f}
f (r Nothing, (\a r -> r (Just (a,r)))) = f (r, (\a r -> r)) (Just (a,r))
= {def. f}
f (r Nothing, (\a r -> r (Just (a,r)))) = (\a r -> r) a r
= {eta-reduction}
f (r Nothing, (\a r -> r (Just (a,r)))) = r
= {introduce Nothing}
f (r Nothing, (\a r -> r (Just (a,r)))) Nothing = r Nothing
= {def. f}
r Nothing = r Nothing

Because x was arbitrary, this holds for all x.

Therefore, it holds that (1) and (2) return equal results for equal arguments, and are thus isomorphic.