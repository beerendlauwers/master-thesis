{-# OPTIONS_GHC -XGADTs #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE KindSignatures #-}
{-# LANGUAGE GADTs #-}

> module BeerendLauwers1 where

Beerend Lauwers
3720942

Exercise 1

a, b, c) 

data Tree a b	:	Regular					[ * -> * -> * ]				a :+: (Tree a b) :x: b :x: (Tree a b)
data Glist f a	:	Regular, Higher-Order	[ ( * -> * ) -> * -> * ]	Unit :+: a :x: (f a)
data Bush a		:	Nested					[ * -> * ]					a :x: (GList :x: Bush :x: (Bush a)) -- ?
data HFix f a	:	Regular, Higher-Order	[ ( * -> * ) -> * -> * ]	-- ?
data Exists b	:	Regular, Higher-Order	[ * -> * ]					[ * -> ( * -> * ) -> * ] -- ?											
data Exp		:	Regular					[ * -> * ] -- ?				-- ?


Exercice 2

a)

> data Exp where
>   Bool :: Bool -> Exp
>   Int ::Int -> Exp
>   IsZero :: Exp -> Exp
>   Add :: Exp -> Exp -> Exp
>   If :: Exp -> Exp -> Exp -> Exp

(This makes type signatures a bit more sane)

> type Result =  Maybe (Either Int Bool)

> eval :: Exp -> Result
> eval (Bool x) = Just (Right x)
> eval (Int x) = Just (Left x)
> eval (IsZero exp) = case (eval exp) of
>                       (Just (Left x)) -> if x == 0 then Just (Right True) else Just (Right False)
>                       otherwise -> error "Invalid expression: isZero expects an expression that evaluates to an Int!"
> eval (Add e1 e2) = case (eval e1) of
>                      (Just (Left x)) -> case (eval e2) of
>                                           (Just (Left y)) -> (Just (Left (x+y)))
>                                           otherwise -> error "Invalid expression: 'Add' expects two integer expressions (second one is not)!"
>                      otherwise -> error "Invalid expression: 'Add' expects two integer expressions (first one is not)!"
> eval (If pred tru fals) = case (eval pred) of
>                             (Just (Right x)) -> if x == True then (eval tru) else (eval fals)
>                             otherwise -> error "Invalid expression: 'If' expects a boolean expression as its first argument!"

Test cases:

> works = eval $ If (IsZero (Int 0)) (Add (Int 5) (Int 5)) (Add (Int 5) (Int 0))
> fails1 = eval $  If (IsZero (Bool False)) (Add (Int 5) (Int 5)) (Add (Int 5) (Int 0))
> fails2 = eval $  If (Int 5) (Add (Int 5) (Int 5)) (Add (Int 5) (Int 0))
> fails3 = eval $  If (IsZero (Int 0)) (Add (Int 5) (Bool False)) (Add (Int 5) (Int 0))
> fails4 = eval $  If (IsZero (Int 0)) (Add (Bool False) (Int 5)) (Add (Int 5) (Int 0))

b) ??

> data ExpF where
>   EOR :: ExpF
>   BoolF :: Bool -> ExpF
>   IntF :: Int -> ExpF
>   IsZeroF :: ExpF
>   AddF :: ExpF -> ExpF
>   IfF :: ExpF -> ExpF -> ExpF

> newtype Fix f = In { out :: f (Fix f) }
> type Exp' = Fix ExpF

c)

> instance (Functor ExpF) where
>   

> evalAlg :: 

