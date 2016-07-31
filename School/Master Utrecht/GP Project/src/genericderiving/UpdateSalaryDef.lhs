> {-# LANGUAGE DefaultSignatures #-}
> {-# LANGUAGE TypeOperators #-}
> {-# LANGUAGE MultiParamTypeClasses #-}
> {-# LANGUAGE FlexibleContexts #-}

> module UpdateSalaryDef where

> import Generics.Deriving
> import CompanyDatatypes

-- default definition

> updateSalDef :: (Generic a, UpdateSal1 (Rep a)) => Float -> a -> a
> updateSalDef x = to . (updateSal1 x) . from

-- UpdateSal class

> class UpdateSal a where
>   updateSal :: Float -> a -> a
>   default updateSal :: (Generic a, UpdateSal1 (Rep a)) => Float -> a -> a
>   updateSal x = updateSalDef x

-- UpdateSal1 class

> class UpdateSal1 f where
>   updateSal1 :: Float -> f x -> f x

> instance UpdateSal1 U1 where
>   updateSal1 _ U1 = U1

> instance (UpdateSal1 f) => UpdateSal1 (M1 i c f) where
>   updateSal1 v (M1 x) = M1 (updateSal1 v x)

> instance (UpdateSal1 f, UpdateSal1 g) => UpdateSal1 (f :+: g) where
>   updateSal1 v (L1 x) = L1 (updateSal1 v x)
>   updateSal1 v (R1 x) = R1 (updateSal1 v x)

> instance (UpdateSal1 f, UpdateSal1 g) => UpdateSal1 (f :*: g) where
>   updateSal1 v (a :*: b) = (updateSal1 v a) :*: (updateSal1 v b)

> instance (UpdateSal a) => UpdateSal1 (K1 i a) where
>   updateSal1 v (K1 a) = K1 (updateSal v a)

-- Primitive instances

> instance UpdateSal Int where
>   updateSal v x = x

> instance UpdateSal Char where
>   updateSal v x = x

-- List

> instance (UpdateSal a) => UpdateSal [a]

-- Company

> instance UpdateSal Company
> instance UpdateSal Dept
> instance UpdateSal Unit
> instance UpdateSal Employee
> instance UpdateSal Person
> instance UpdateSal Salary where
>   updateSal v (S x) = (S (x * (1+v))) -- The interesting part

> updateSalary :: (UpdateSal a) => Float -> a -> a
> updateSalary = updateSal
