{-# OPTIONS_GHC -O0 #-}
-- Running this without this flag results in an "out of memory" error:
-- [2 of 3] Compiling Assignment.Fix   ( src\Assignment\Fix.hs, dist\build\Assignment\Fix.o )
-- ghc.exe: out of memory

module Assignment.Fix where

import Data.Function (fix)

-- | foldr as an application of 'fix' to a term that is not recursive.
foldr' :: ((a -> b -> b) -> b -> [a] -> b) -> (a -> b -> b) -> b -> [a] -> b
foldr' _ _ z []     = z
foldr' f k z (x:xs) = k x $ f k z xs

-- | Datatype for the recursion.
data F a = F { unF :: F a -> a }

-- Example that won't type check in Haskell:
--y = \f -> (\x -> f(x x)) (\x -> f(x x))

-- Examples that will typecheck in Haskell, using the datatype F.
test = F(\x -> unF x x)
test2 = F(\x -> F(\y -> unF (unF x x) (unF x x)))
test3 = F(\x -> unF (F(\x -> unF x x)) (F(\x -> unF x x)))
test4 = F( unF (F(\x -> unF x x)) (F(\x -> unF x x)) )
test5 = F(\f -> unF (F(\x -> unF x x)) (F(\x -> unF x x)) )
test6 = \f -> (\x -> f (unF x x))

-- | y lambda term, anotated with the F data type.
y = \f -> (\x -> f (unF x x)) (F(\x -> f (unF x x)))