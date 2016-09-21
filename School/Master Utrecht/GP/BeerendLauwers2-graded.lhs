> {-# LANGUAGE TypeOperators, KindSignatures, GADTs, DeriveDataTypeable, FlexibleContexts, FlexibleInstances, TypeSynonymInstances, MultiParamTypeClasses, OverlappingInstances, IncoherentInstances #-}
> {-# OPTIONS_GHC -XTypeOperators -XDeriveDataTypeable -XFlexibleContexts #-}

> module BeerendLauwers2 where
> import Data.Generics
> import Data.Char
> import Generics.EMGM as EMGM hiding (max)
> import Generics.EMGM.Functions.Collect
> import Generics.EMGM.Functions.Everywhere
> import Control.Applicative (Alternative, pure)
> import Generics.EMGM.Functions.Crush

Example Data
-- The organisational structure of a company

> data Company  = C [Dept]               deriving (Eq, Show, Typeable, Data)
> data Dept     = D Name Manager [Coll]  deriving (Eq, Show, Typeable, Data)
> data Coll     = PU Employee | DU Dept  deriving (Eq, Show, Typeable, Data)
> data Employee = E Person Salary        deriving (Eq, Show, Typeable, Data)
> data Person   = P Name Address         deriving (Eq, Show, Typeable, Data)
> data Salary   = S Int                  deriving (Eq, Show, Typeable, Data)
> type Manager  = Employee
> type Name     = String
> type Address  = String

-- An illustrative company

> genCom :: Company
> genCom = C [D "Research" laemmel [PU joost, PU marlow],
>             D "Strategy" blair   []]

-- A typo for the sake of testing equality;
-- (cf. lammel vs. laemmel)

> genCom' :: Company
> genCom' = C [D "Research" lammel [PU joost, PU marlow],
>              D "Strategy" blair   []]

> lammel, laemmel, joost, blair :: Employee
> lammel  = E (P "Lammel" "Amsterdam") (S 8000)
> laemmel = E (P "Laemmel" "Amsterdam") (S 8000)
> joost   = E (P "Joost"   "Amsterdam") (S 1000)
> marlow  = E (P "Marlow"  "Cambridge") (S 2000)
> blair   = E (P "Blair"   "London")    (S 100000)

-- Some more test data

> person1 = P "Lazy" "Home"
> dept1   = D "Useless" (E person1 undefined) []

Exercise 1
Grade: 1 / 1

> type Result =  (Int, Maybe Char, [String])
 
> typeinfo' :: GenericQ [Result]
> typeinfo' = (\x -> concat (gmapQ typeinfo' x) ++ extractStrings (showConstr $ toConstr x) ) `extQ` extractInts `extQ` extractChars
> extractInts x = [(x, Nothing, [])]
> extractChars x = [(0, Just x, [])]
> extractStrings x = [(0, Nothing, [x])]

> typeinfo x = let results = typeinfo' x
>              in foldr foldResults (0, Nothing, []) results
>  where
>   getMaxChar (Just x) (Just y) = Just $ chr $ max (ord x) (ord y)
>   getMaxChar (Just x) _ = Just x
>   getMaxChar _ (Just x) = Just x
>   getMaxChar _  _ = Nothing
>   foldResults (a1, b1, c1) (a2, b2, c2) = ( a1 + a2, getMaxChar b1 b2, c1 ++ c2 )

> exTest1 = typeinfo genCom
> exTest2 = typeinfo person1

Exercise 2a
Grade: 0.5 / 1.5
Comment: No toSpine for primitives or List or Pair, odd Exp Type which forces you to jump through hoops in the toSpine function

Spine data

> data Type :: * -> * where
>  Char  :: Type Char
>  Int   :: Type Int
>  Bool  :: Type Bool
>  List  :: Type a -> Type [a]
>  Pair  :: Type a -> Type b -> Type (a, b)
>  Exp :: Type (Exp a)

> data Typed a = (:>) { typeOf :: Type a, val :: a }

> infixl 1 :>

> data Constr2 a = Constr { constr :: a, name :: String }

> data Spine :: * -> * where
>  Con     :: Constr2 a -> Spine a
>  (:<>:)  :: Spine (a -> b) -> Typed a -> Spine b

> infixl 0 :<>:

Exp Data

> data Exp :: * -> * where
>  IntE   :: Int -> Exp Int
>  BoolE  :: Bool  -> Exp Bool
>  IsZero :: Exp Int -> Exp Bool
>  Add    :: Exp Int -> Exp Int -> Exp Int
>  If     :: Exp Bool -> Exp a -> Exp a -> Exp a

Actual Exercise

> fromSpine :: Spine a -> a
> fromSpine (Con (Constr x _)) = x
> fromSpine (f :<>: x) = (fromSpine f) (val x)

> toSpine :: Typed a -> Spine a
> toSpine (Exp :> IntE x) = Con $ Constr (IntE x) "IntE"
> toSpine (Exp :> BoolE x) = Con $ Constr (BoolE x) "BoolE"
> toSpine (Exp :> (IsZero x)) = Con (Constr IsZero "IsZero") :<>: (Exp :> x)
> toSpine (Exp :> (Add a b)) = Con (Constr Add "Add") :<>: (Exp :> a) :<>: (Exp :> b)
> toSpine (Exp :> (If (BoolE x) tru fal)) = Con (Constr If "If") :<>: (Exp :> BoolE x) :<>: (trueBranch tru fal) :<>: (falseBranch tru fal)
>  where
>   isBoolean :: Exp a -> Bool
>   isBoolean (IntE x) = False
>   isBoolean (BoolE x) = True
>   isBoolean (IsZero x) = False
>   isBoolean (Add x y) = False
>   isBoolean (If p t f) = isBoolean t
>   trueBranch t f = if isBoolean t == isBoolean f then Exp :> t else error "If branches have to be the same type"
>   falseBranch t f = if isBoolean t == isBoolean f then Exp :> f else error "If branches have to be the same type" 


> typedEx = (Exp :> (If (BoolE True) (Add (IntE 5) (IntE 5)) (IntE 3)))
> ex2aTest = toSpine typedEx

Show function (always handy)

> gShowS :: Spine a -> String
> gShowS (Con (Constr x text)) = text
> gShowS (f :<>: x) = (gShowS f) ++ gShow x

> gShow :: Typed a -> String
> gShow (Int :> x) = Prelude.show x
> gShow (Char :> x) = Prelude.show x
> gShow (Bool :> x) = Prelude.show x
> gShow (List a :> (x:[])) = gShow (a :> x)
> gShow (List a :> (x:xs)) = gShow (a :> x) ++ ", " ++ gShow (List a :> xs)
> gShow (Pair ta tb :> (a,b)) = "Pair (" ++ gShow (ta :> a) ++ ") (" ++ gShow (tb :> b) ++ ")"
> gShow (Exp :> IntE x) = "(IntE " ++ Prelude.show x ++ ")"
> gShow (Exp :> BoolE x) = "(BoolE " ++ Prelude.show x ++ ")"
> gShow (Exp :> IsZero a) = "(IsZero " ++ gShow (Exp :> a) ++ ")"
> gShow (Exp :> Add s1 s2) = "(Add " ++ gShow (Exp :> s1) ++ " and " ++ gShow (Exp :> s2) ++ ")"
> gShow (Exp :> If p t f) = "If " ++ gShow (Exp :> p) ++ " Then " ++ gShow (Exp :> t) ++ " Else " ++ gShow (Exp :> f)

Exercise 3
Grade: 0.7 / 1
Comment: Works, but you forgot to make an instance for rcon

> newtype Depth a = Depth { selDepth :: a -> Int }

> depth_unit  EMGM.Unit = 0
> depth_int   i    = 0
> depth_integer i  = 0
> depth_float i    = 0
> depth_double i   = 0
> depth_char  i    = 0
> depth_plus l r (EMGM.L a) = 1 + (selDepth l a)
> depth_plus l r (EMGM.R a) = 1 + (selDepth r a)
> depth_prod f s (a EMGM.:*: b) = (max (selDepth f a) (selDepth s b))
> depth_rtype ep t x = selDepth t (from ep x)

> instance EMGM.Generic Depth where
>  runit = Depth depth_unit
>  rint = Depth depth_int
>  rinteger = Depth depth_integer
>  rfloat = Depth depth_float
>  rdouble = Depth depth_double
>  rchar = Depth depth_char
>  rsum l r = Depth (depth_plus l r)
>  rprod f s = Depth (depth_prod f s)
>  rtype ep t = Depth (depth_rtype ep t)

> depth :: (Rep Depth a) => a -> Int
> depth = selDepth EMGM.rep

Exercise 4a
Grade: 1.8 / 2 
Comment: Didn't actually write an instance of frep, even though you have a lot of code for it

> data Zig a b = ZigEnd a | ZigCons a (Zag a b) deriving Show
> data Zag a b = ZagEnd b | ZagCons b (Zig a b) deriving Show

> type ZigS a b = (a EMGM.:+: (a EMGM.:*: Zag a b))
> epZig = EMGM.EP fromZig toZig
>  where
>    fromZig (ZigEnd a) = EMGM.L a
>    fromZig (ZigCons a zags) = EMGM.R (a EMGM.:*: zags) 
>    toZig (EMGM.L a) = ZigEnd a
>    toZig (EMGM.R (a EMGM.:*: zags)) = ZigCons a zags

> instance HasEP (Zig a b) (ZigS a b) where
>  epOf _ = epZig

> type ZagS a b = (b EMGM.:+: (b EMGM.:*: Zig a b))
> epZag = EMGM.EP fromZag toZag
>  where
>    fromZag (ZagEnd a) = EMGM.L a
>    fromZag (ZagCons a zigs) = EMGM.R (a EMGM.:*: zigs) 
>    toZag (EMGM.L a) = ZagEnd a
>    toZag (EMGM.R (a EMGM.:*: zigs)) = ZagCons a zigs

> instance HasEP (Zag a b) (ZagS a b) where
>  epOf _ = epZag

> genEndDescr x = ConDescr x 1 False EMGM.Prefix
> genConsDescr x = ConDescr x 2 False EMGM.Prefix

> rZig :: (EMGM.Generic g, Rep g a, Rep g b) => g ( Zig a b )
> rZig = rtype epZig (rsum (rcon (genEndDescr "ZigEnd") rep) (rcon (genConsDescr "ZigCons") (rprod rep rep)))
> rZag :: (EMGM.Generic g, Rep g a, Rep g b) => g ( Zag a b )
> rZag = rtype epZag (rsum (rcon (genEndDescr "ZagEnd") rep) (rcon (genConsDescr "ZagCons") (rprod rep rep)))

> instance (EMGM.Generic g, Rep g a, Rep g b) => Rep g (Zig a b) where
>   rep = rZig
> instance (EMGM.Generic g, Rep g a, Rep g b) => Rep g (Zag a b) where
>   rep = rZag

> frZig :: (EMGM.Generic g) => g a -> g b -> g (Zig a b)
> frZig a b = rtype epZig ((rcon (genEndDescr "ZigEnd") a) 
>             `rsum`
>             (rcon (genConsDescr "ZigCons") (rprod a (frZag a b))))
> frZag :: (EMGM.Generic g) => g a -> g b -> g (Zag a b)
> frZag a b = rtype epZag ((rcon (genEndDescr "ZagEnd") b) 
>             `rsum`
>             (rcon (genConsDescr "ZagCons") (rprod b (frZig a b))))

> fr2Zig :: (Generic2 g) => g a1 a2 -> g b1 b2 -> g (Zig a1 b1) (Zig a2 b2)
> fr2Zig a b = rtype2 epZig epZig
>              ((rcon2 (genEndDescr "ZigEnd") a)
>              `rsum2`
>              (rcon2 (genConsDescr "ZigCons") (rprod2 a (fr2Zag a b))))

> fr2Zag :: (Generic2 g) => g a1 a2 -> g b1 b2 -> g (Zag a1 b1) (Zag a2 b2)
> fr2Zag a b = rtype2 epZag epZag
>             ((rcon2 (genEndDescr "ZagEnd") b)
>             `rsum2`
>             (rcon2 (genConsDescr "ZagCons") (rprod2 b (fr2Zig a b))))

> bifr2Zig :: (Generic2 g) => g a1 a2 -> g b1 b2 -> g (Zig a1 b1) (Zig a2 b2)
> bifr2Zig = fr2Zig
> bifr2Zag :: (Generic2 g) => g a1 a2 -> g b1 b2 -> g (Zag a1 b1) (Zag a2 b2)
> bifr2Zag = fr2Zag

> fr3Zig :: (Generic3 g) => g a1 a2 a3 -> g b1 b2 b3 -> g (Zig a1 b1) (Zig a2 b2) (Zig a3 b3)
> fr3Zig a b = rtype3 epZig epZig epZig
>              ((rcon3 (genEndDescr "ZigEnd") a)
>              `rsum3`
>              (rcon3 (genConsDescr "ZigCons") (rprod3 a (fr3Zag a b))))
> fr3Zag :: (Generic3 g) => g a1 a2 a3 -> g b1 b2 b3 -> g (Zag a1 b1) (Zag a2 b2) (Zag a3 b3)
> fr3Zag a b = rtype3 epZag epZag epZag
>              ((rcon3 (genEndDescr "ZagEnd") b)
>              `rsum3`
>              (rcon3 (genConsDescr "ZagCons") (rprod3 b (fr3Zig a b))))

> instance (Generic2 g) => BiFRep2 g Zig where
>   bifrep2 = bifr2Zig
> instance (Generic2 g) => BiFRep2 g Zag where
>   bifrep2 = bifr2Zag

> instance (Alternative f) => Rep (Collect f (Zig a b)) (Zig a b) where
>   rep = Collect pure
> instance (Alternative f) => Rep (Collect f (Zag a b)) (Zag a b) where
>  rep = Collect pure

> instance (Rep (Everywhere (Zig a b)) a, Rep (Everywhere (Zig a b)) b)
>          => Rep (Everywhere (Zig a b)) (Zig a b) where
>   rep = Everywhere app
>     where
>       app f x =
>         case x of
>           ZigEnd a -> f ( ZigEnd (selEverywhere rep f a))
>           ZigCons a zag -> f ( ZigCons (selEverywhere rep f a) (selEverywhere rep f zag))

> instance (Rep (Everywhere (Zag a b)) a, Rep (Everywhere (Zag a b)) b)
>          => Rep (Everywhere (Zag a b)) (Zag a b) where
>   rep = Everywhere app
>     where
>       app f x =
>         case x of
>           ZagEnd b -> f ( ZagEnd (selEverywhere rep f b))
>           ZagCons b zig -> f ( ZagCons (selEverywhere rep f b) (selEverywhere rep f zig))

> instance Rep (Everywhere' (Zig a b)) (Zig a b) where
>   rep = Everywhere' ($)
> instance Rep (Everywhere' (Zag a b)) (Zag a b) where
>   rep = Everywhere' ($)

Exercise 4b.i
Grade: 0.15 / 0.5
Comment: Works, but could have been a lot simpler with collect

> newtype CollectChars a = CollectChars { selCollectChars :: a -> [Char] }

> c_unit  EMGM.Unit = []
> c_int   i    = []
> c_integer i  = []
> c_float i    = []
> c_double i   = []
> c_char  i    = [i]
> c_plus l r (EMGM.L a) = (selCollectChars l a)
> c_plus l r (EMGM.R a) = (selCollectChars r a)
> c_prod f s (a EMGM.:*: b) = (selCollectChars f a) ++ (selCollectChars s b)
> c_rtype ep t x = selCollectChars t (from ep x)

> instance EMGM.Generic CollectChars where
>  runit = CollectChars c_unit
>  rint = CollectChars c_int
>  rinteger = CollectChars c_integer
>  rfloat = CollectChars c_float
>  rdouble = CollectChars c_double
>  rchar = CollectChars c_char
>  rsum l r = CollectChars (c_plus l r)
>  rprod f s = CollectChars (c_prod f s)
>  rtype ep t = CollectChars (c_rtype ep t)

> collectChars' :: (Rep CollectChars a) => a -> [Char]
> collectChars' = selCollectChars EMGM.rep

> collectChars :: (Rep CollectChars a, Rep CollectChars b) => Zig a b -> [Char]
> collectChars = collectChars'

> testCollectChars = collectChars (ZigCons "fff" (ZagCons 'a' (ZigEnd "bbb")))

Exercise 4b.ii

ABANDON ALL HOPE ALL YE WHO ENTER HERE

> type ResultCollectChar2 = [([Char],String)]

> newtype CollectChars2 a = CollectChars2 { selCollectChars2 :: a -> ResultCollectChar2 }

> c_unit2  EMGM.Unit = [([],[])]
> c_int2   i    = [([],[])]
> c_integer2 i  = [([],[])]
> c_float2 i    = [([],[])]
> c_double2 i   = [([],[])]
> c_char2  i    = [([i],[])]
> c_plus2 l r (EMGM.L a) = selCollectChars2 l a
> c_plus2 l r (EMGM.R a) = selCollectChars2 r a
> c_prod2 f s (a EMGM.:*: b) = selCollectChars2 f a ++ selCollectChars2 s b
> c_rtype2 ep t x = selCollectChars2 t (from ep x)
> c_rcon2 (ConDescr name _ _ _) r x = [([],name)] ++ selCollectChars2 r x

> instance EMGM.Generic CollectChars2 where
>  runit = CollectChars2 c_unit2
>  rint = CollectChars2 c_int2
>  rinteger = CollectChars2 c_integer2
>  rfloat = CollectChars2 c_float2
>  rdouble = CollectChars2 c_double2
>  rchar = CollectChars2 c_char2
>  rsum l r = CollectChars2 (c_plus2 l r)
>  rprod f s = CollectChars2 (c_prod2 f s)
>  rtype ep t = CollectChars2 (c_rtype2 ep t)
>  rcon desc r = CollectChars2 (c_rcon2 desc r)

> collectChars2 :: (Rep CollectChars2 a) => a -> ResultCollectChar2
> collectChars2 = selCollectChars2 EMGM.rep
 
 dapsap list = map (checkZigZag list) list
 checkZigZag l (_,"ZigEnd") = []
 checkZigZag l (_,"ZigCons") = []
 checkZigZag l (d,"ZagCons") = d
 checkZigZag l (d,"ZagEnd") = d
 checkZigZag l x = findNearestZigZag l x

 findNearestZigZag l item = case find (==item) l of
                               Just x -> createNewValue (searchList l (x-1)) (searchList l (x+1))

 searchList l x = if x == 0 -- Should be a Zig or Zag
                    then case (l !! x) of
                          (_,"ZigEnd") -> "ZigEnd"
                          (_,"ZigCons") -> "ZigCons"
                    else
                    

FINAL GRADE: 4.15 / 10