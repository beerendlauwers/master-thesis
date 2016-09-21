> {-# LANGUAGE RankNTypes,TypeOperators,GADTs,KindSignatures,TypeFamilies #-}

> module Two where

> data Tree a b = Tip a | Branch (Tree a b) b (Tree a b)
> data GList f a = GNil | GCons a (f a)
> data Bush a = Bush a (GList Bush (Bush a))
> data HFix f a = HIn {hout :: f (HFix f) a}

> data Exists b where
>   Exists :: a -> (a -> b) -> Exists b

> data Exp where 
>   Bool :: Bool -> Exp
>   Int :: Int -> Exp
>   IsZero :: Exp -> Exp
>   Add :: Exp -> Exp -> Exp
>   If :: Exp -> Exp -> Exp -> Exp

(1a) Grade: 0.35 / 0.5

Tree is a regular, parametrised, recursive data type. It has two type 
parameters. 

GList is a parameterised, higher-kind finite data type.

Bush is nested and non-regular. Its recursive instance appears 
within a GList.

HFix is similar to a mutually recursive data type. HFix f a refers to f (HFix f) a, which in 
turn may refer to some HFix f b. It is non-regular.

(1b) Grade: 0.5 / 0.5

Tree :: * -> * -> *
GList :: (* -> *) -> * -> *
Bush :: * -> *
HFix :: ((* -> *) -> * -> *) -> * -> *
Exists :: * -> *
Exp :: *

> data Unit = Unit
> data (:+:) a b = L a | R b
> data (:*:) a b = (:*:) a b

> data EP t r = EP {from :: (t -> r), 
>                   to :: (r -> t)}

> data Rep :: * -> * where
>   RUnit :: Rep Unit
>   RInt :: Rep Int
>   RChar :: Rep Char
>   RSum :: Rep a -> Rep b -> Rep (a :+: b)
>   RProd :: Rep a -> Rep b -> Rep (a :*: b)
>   RType :: EP t r -> Rep r -> Rep t
>   RCon :: String -> Rep a -> Rep a
  
> data List a = Nil | Cons a (List a)
> type ListS a = Unit :+: (a :*: List a)

> fromList :: List a -> ListS a
> fromList Nil = L Unit
> fromList (Cons a as) = R (a :*: as)

> toList :: ListS a -> List a
> toList (L Unit) = Nil
> toList (R (a :*: as)) = Cons a as

> rList :: Rep a -> Rep (List a)
> rList rA = RType (EP fromList toList)
>                  (RSum RUnit (RProd rA $ rList rA))

(1c) Grade: 0.5 / 0.5

Representation of Tree

> type TreeS a b = a :+: (Tree a b :*: b :*: Tree a b)

> fromTree :: Tree a b -> TreeS a b
> fromTree (Tip a) = L a
> fromTree (Branch l b r) = R (l :*: b :*: r)

> toTree :: TreeS a b -> Tree a b
> toTree (L a) = Tip a
> toTree (R (l :*: b :*: r)) = Branch l b r

> rTree :: Rep a -> Rep b -> Rep (Tree a b)
> rTree rA rB = RType (EP fromTree toTree) $ RSum rA rBranch
>   where rBranch = RProd (RProd (rTree rA rB) rB) $ rTree rA rB
        
Representation of GList
          
> type GListS f a = Unit :+: (a :*: f a)

> fromGList :: GList f a -> GListS f a
> fromGList GNil = L Unit

> toGList :: GListS f a -> GList f a
> toGList (L Unit) = GNil
> toGList (R (a :*: fa)) = GCons a fa

> rGList :: Rep a -> Rep (g a) -> Rep (GList g a)
> rGList rA rGA = RType (EP fromGList toGList) rGListS
>   where rGListS = RSum RUnit (RProd rA rGA)

Representation of Bush        

> type BushS a = a :*: GList Bush (Bush a)

> toBush :: BushS a -> Bush a
> toBush (a :*: b) = Bush a b

> fromBush :: Bush a -> BushS a
> fromBush (Bush a b) = a :*: b

> rBush :: Rep a -> Rep (Bush a)
> rBush rA = RType (EP fromBush toBush) rBushS
>   where rBushS = RProd rA $ rGList (rBush rA) (rBush (rBush rA))        

Representation of HFix          
          
> type HFixS f a = f (HFix f) a

> fromHFix :: HFix f a -> HFixS f a
> fromHFix (HIn x) = x

> toHFix :: HFixS f a -> HFix f a
> toHFix x = HIn x

> rHFix :: Rep (HFixS f a) -> Rep (HFix f a)
> rHFix rB = RType (EP fromHFix toHFix) rB

(Exists b) is not possible because the there is no representation for
forall a . a.

Representation of Exp

representation of Bool is required first

> type BoolS = Unit :+: Unit

> fromBool :: Bool -> BoolS
> fromBool x | x = R Unit
>            | not x = L Unit
                     
> toBool :: BoolS -> Bool
> toBool (R Unit) = True
> toBool (L Unit) = False                                

> rBool :: Rep Bool
> rBool = RType (EP fromBool toBool) rBoolS
>   where rBoolS = RSum RUnit RUnit
        
> type ExpS = Bool :+: Int :+: Exp :+: (Exp :*: Exp) :+: (Exp :*: Exp :*: Exp)

> fromExp :: Exp -> ExpS
> fromExp (If a b c) = R (a :*: b :*: c)
> fromExp (Add a b) = (L (R (a :*: b)))
> fromExp (IsZero a) = (L (L (R a)))
> fromExp (Int a) = (L (L (L (R a))))
> fromExp (Bool a) = (L (L (L (L a))))

> toExp :: ExpS -> Exp
> toExp (R (a :*: b :*: c)) = If a b c
> toExp (L (R (a :*: b))) = Add a b
> toExp (L (L (R a))) = IsZero a
> toExp (L (L (L (R a)))) = Int a
> toExp (L (L (L (L a)))) = Bool a

> rExp :: Rep Exp
> rExp = RType (EP fromExp toExp) rExpS
>   where rExpS = RSum (RSum (RSum (RSum rBool RInt) rExp) (RProd rExp rExp)) (RProd (RProd rExp rExp) rExp)
        
(2a) Grade: 0.3 / 0.5 (forgot recursion sometimes)
          
> eval :: Exp -> Maybe (Either Int Bool)
> eval exp = case exp of
>   Bool x -> Just $ Right x
>   Int x -> Just $ Left x
>   IsZero (Int x) -> Just $ Right (x == 0)
>   Add (Int x) (Int y) -> Just $ Left (x + y)
>   If (Bool p) q r -> eval $ if p then q else r
>   _ -> Nothing
  
> newtype Fix f = In {out :: f (Fix f)}

(2b) Grade: 0.5 / 0.5

> data ExpF r = BoolF Bool
>             | IntF Int
>             | IsZeroF r
>             | AddF r r
>             | IfF r r r
              
> type Exp' = Fix ExpF

(2c) Grade: 1 / 1

> instance Functor ExpF where
>   fmap f exp = case exp of
>     IsZeroF r -> IsZeroF $ f r
>     AddF r s -> AddF (f r) (f s)
>     IfF r s t -> IfF (f r) (f s) (f t)
>     BoolF x -> BoolF x
>     IntF x -> IntF x
    
> fold :: Functor f => (f a -> a) -> Fix f -> a
> fold f = f . fmap (fold f) . out

> evalAlg :: ExpF (Maybe (Either Int Bool)) -> Maybe (Either Int Bool)
> evalAlg exp = case exp of
>   IntF x -> Just $ Left x
>   BoolF x -> Just $ Right x
>   AddF (Just (Left x)) (Just (Left y)) -> Just $ Left (x + y)
>   IsZeroF (Just (Left x)) -> Just $ Right (x == 0)
>   IfF (Just (Right p)) q r -> if p then q else r
>   _ -> Nothing
  
> eval' :: Exp' -> Maybe (Either Int Bool)
> eval' = fold evalAlg

(2d) Grade: 0.9 / 1 (no example of impossible value)

> data ExpTF :: (* -> *) -> * -> * where
>   IntTF :: Int -> ExpTF r Int
>   BoolTF :: Bool -> ExpTF r Bool
>   IsZeroTF :: r Int -> ExpTF r Bool
>   AddTF :: r Int -> r Int -> ExpTF r Int
>   IfTF :: r Bool -> r s -> r s -> ExpTF r s
  
> type ExpT' = HFix ExpTF

> class HFunctor f where
>   hfmap :: (forall b . g b -> h b) -> f g a -> f h a

(2e) 1.5 / 1.5

> instance HFunctor ExpTF where
>   hfmap f x = case x of
>     IsZeroTF x -> IsZeroTF $ f x
>     AddTF x y -> AddTF (f x) (f y)
>     IfTF p q r -> IfTF (f p) (f q) (f r)
>     IntTF x -> IntTF x
>     BoolTF x -> BoolTF x

> hfold :: (HFunctor f) => (forall b . f r b -> r b) -> HFix f a -> r a
> hfold f = f . hfmap (hfold f) . hout

> newtype Id a = Id {unId :: a}

> evalT' :: ExpT' a -> a
> evalT' = unId . hfold evalAlgT

> evalAlgT :: ExpTF Id a -> Id a
> evalAlgT exp = case exp of
>   IntTF x -> Id x
>   BoolTF x -> Id x
>   IsZeroTF (Id x) -> Id $ x == 0
>   AddTF (Id x) (Id y) -> Id $ x + y
>   IfTF (Id p) (Id q) (Id r) -> if p then Id q else Id r

(3) 1.5 / 2.0 (3 generic functions while a single one would have sufficed)

> sumInt :: Rep a -> a -> Int
> sumInt RInt x = x
> sumInt (RSum rx _) (L x) = sumInt rx x
> sumInt (RSum _ ry) (R y) = sumInt ry y
> sumInt (RProd rx ry) (x :*: y) = sumInt rx x + sumInt ry y

otherwise nothing is contributed to the sum:

> sumInt _ _ = 0

> maxChar :: Rep a -> a -> Char
> maxChar RChar c = c
> maxChar (RSum rx _) (L x) = maxChar rx x
> maxChar (RSum _ ry) (R y) = maxChar ry y
> maxChar (RProd rx ry) (x :*: y) = max (maxChar rx x) (maxChar ry y)

(toEnum 0 :: Char) gives the lowest character. Therefore max x 
(toEnum 0) == x.

> maxChar _ _ = toEnum 0 :: Char

> consNames :: Rep a -> a -> [String]
> consNames (RCon name ra) a = name : consNames ra a
> consNames (RSum rx _) (L x) = consNames rx x
> consNames (RSum _ ry) (R y) = consNames ry y
> consNames (RProd rx ry) (x :*: y) = consNames rx x ++ consNames ry y
> consNames _ _ = []

> typeInfo :: Rep a -> a -> (Int, Char, [String])
> typeInfo ra a = (sumInt ra a, maxChar ra a, consNames ra a)

(4) 1.7 / 2.0 (instance Either a b doesn't do constraints, forgot recursion)

> class Desum a where
>   type Desummed a
>   desum :: a -> Desummed a

> instance Desum (Either a b) where
>   type Desummed (Either a b) = (Maybe a, Maybe b)
>   desum (Left a) = (Just a, Nothing)
>   desum (Right b) = (Nothing, Just b)

> instance Desum () where
>   type Desummed () = ()
>   desum () = ()

> instance Desum Int where
>   type Desummed Int = Int
>   desum x = x
  
> instance (Desum a, Desum b) => Desum (a, b) where
>   type Desummed (a, b) = (Desummed a, Desummed b)
>   desum (a, b) = (desum a, desum b)

GRADE TOTAL: 0.35 + 0.5 + 0.5 + 0.3 + 0.5 + 1 + 0.9 + 1.5 + 1.5 + 1.7 = 8.75 