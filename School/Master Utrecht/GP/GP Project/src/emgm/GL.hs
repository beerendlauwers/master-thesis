{-# LANGUAGE TypeOperators, MultiParamTypeClasses, FlexibleInstances, FlexibleContexts #-}
module GL where

import Prettier hiding (Pretty, pretty, char, int, integer, float, block, render, prettyList, empty)
import qualified Prettier
--import Data.Generics hiding (Generic) 
import Generics.EMGM

data Bit = O | I

class ShowBin2 t where
    showBin2 :: t -> [Bit]
instance ShowBin2 Char where
    showBin2 = showBinChar
instance ShowBin2 Int where
    showBin2 = showBinInt
instance ShowBin2 a => ShowBin2 [a] where
    showBin2 []        = [O]
    showBin2 (x : xs)  = I : (showBin2 x ++ showBin2 xs)

newtype ShowBin a  =  ShowBin { showBin' :: a -> [Bit] }

instance Generic ShowBin where
  runit              =  ShowBin (const [])
  rchar              =  ShowBin showBinChar
  rint               =  ShowBin showBinInt
  rinteger           =  error "Not implemented"
  rdouble            =  error "Not implemented"
  rsum a b           =  ShowBin (\ x -> case x of L l ->  O  :  showBin' a l
                                                  R r ->  I  :  showBin' b r)
  rprod a b          =  ShowBin (\ ( x :*: y) -> showBin' a x ++ showBin' b y)
  rtype iso a        =  ShowBin (\ x -> showBin' a (from iso x))
  rfloat             =  error "Not implemented"

data Unit'       =  Unit'

data a ::+::  b  =  L' a | R' b

data a ::*:: b   =  a ::*:: b

isoList :: EP [a] (Unit :+: (a :*: [a]))
isoList = EP fromList toList

fromList :: [a] -> Unit :+: (a :*: [a])
fromList []               = L Unit
fromList (x:xs)           = R (x :*: xs)

toList :: Unit :+: (a :*: [a]) -> [a]
toList (L Unit)        = []
toList (R (x :*: xs))  = x : xs

class Size a where
    size :: a -> Int
instance Size Int where
    size _ = 1
instance Size Char where
    size _ = 0
instance Size Unit where
    size _ = 0
instance (Size a, Size b) => Size (a :+: b) where
    size (L x)  = size x
    size (R y)  = size y
instance (Size a, Size b) => Size (a :*: b) where
    size (x :*: y) = size x + size y
instance Size a => Size [a] where
    size = size . fromList
instance Size Bool where
    size _ = 1
instance Size a => Size (Tree a) where
    size = size . fromTree

isoTree = EP fromTree toTree

fromTree Empty           = L Unit
fromTree (Fork i l x r)  = R (i :*: (l :*: (x :*: r)))

toTree (L Unit)                        = Empty
toTree (R (i :*: (l :*: (x :*: r))))   = Fork i l x r

type Name   = String
type Arity  = Int

newtype Count a                =  Count { count' :: a -> Int }

instance Generic Count where
   runit                       =  Count (const 0)
   rsum a b                    =  Count (\x -> case x of  L l  ->  count' a l
                                                          R r  ->  count' b r)
   rprod a b                   =  Count (\x -> count' a (outl x) + count' b (outr x))
   rtype ep a                  =  Count (count' a . from ep)
   rchar                       =  Count (const 0)
   rint                        =  Count (const 0)
   rfloat                      =  Count (const 0)
   rinteger                    =  Count (const 0)
   rdouble                     =  Count (const 0)

outl (x :*: y) = x
outr (x :*: y) = y

fsize  :: FunctorRep f => f a -> Int
fsize  =  count' (functorRep (Count (const 1)))

class FunctorRep f where
     functorRep  :: Generic g => g a -> g (f a)

fsum  :: FunctorRep f => f Int -> Int
fsum  = count' (functorRep (Count id))

instance FunctorRep [] where
  functorRep   =  rList

infixr 8 <*>
infixr 7 <|>

(<|>)  :: Generic g => g a -> g b -> g (a :+: b)
(<|>)  = rsum

(<*>)  :: Generic g => g a -> g b -> g (a :*: b)
(<*>)  = rprod

instance FunctorRep Tree where
   functorRep   =  rTree

{- Trying to use the EMGM version
class Rep a where
  rep                     :: (Generic g) => g a
instance Rep Unit where
  rep                     =  runit
instance Rep Char where
  rep                     =  rchar
instance Rep Int where
  rep                     =  rint
instance Rep Float where
  rep                     =  rfloat
instance (Rep a, Rep b) => Rep (a :+: b) where
  rep                     =  rsum rep rep
instance (Rep a, Rep b) => Rep (a :*: b) where
  rep                     =  rprod rep rep
instance Rep a => Rep [a] where
  rep                     =  rList rep
instance Rep a => Rep (Tree a) where
  rep                     = rTree rep
-}

--showBin3 :: Rep t => t -> [Bit]
--showBin3 = showBin' rep

rList :: Generic g => g a -> g [a]
rList a = rtype isoList (rcon (ConDescr "[]" 0 False Prefix) runit `rsum` rcon (ConDescr "(:)" 1 False (Infix RightAssoc 10)) (a `rprod` rList a))

--countZero :: Rep t => t -> Int
--countZero = count' rep

encodeList :: (a -> [Bit]) -> [a] -> [Bit]
encodeList f = showBin' (rList $ ShowBin f)

class Generic g => GenericList g where
    list :: g a -> g [a]
    list = rList

instance GenericList ShowBin where
   list a =  ShowBin (\ x ->  showBinInt (length x) ++
                              concatMap (showBin' a) x)

class RBin' t where
    showbin                    :: t -> [Bit]

instance RBin' Unit where
    showbin                    = showBin' runit
instance RBin' Int where
    showbin                    = showBin' rint
instance RBin' Char where
    showbin                    = showBin' rchar
instance (RBin' a, RBin' b) => RBin' (a :+: b) where
    showbin                    = showBin' (rsum overbin overbin)
instance (RBin' a, RBin' b) => RBin' (a :*: b) where
    showbin                    = showBin' (rprod overbin overbin)

class RCount a where
    count                 :: a -> Int

instance RCount Unit where
    count                 =  count' overCount
instance (RCount a, RCount b) => RCount (a :+: b) where
    count                 =  count' (rsum overCount overCount)
instance (RCount a, RCount b) => RCount (a :*: b) where
    count                 =  count' (rprod overCount overCount)
instance RCount Char where
    count                 =  count' rchar
instance RCount Int where
    count                 =  count' rint

overCount :: RCount a => Count a
overCount = Count count

overbin :: RBin' a => ShowBin a
overbin = ShowBin showbin

instance RBin' a => RBin' [a] where
   showbin = showBin' (list overbin)

class Generic g => GenericBool g where
    bool :: g Bool

instance GenericBool Count where
    bool = Count (const 0)

showBinBool False = [O]
showBinBool True  = [I]

instance GenericBool ShowBin where
    bool = ShowBin showBinBool
instance RCount Bool where
    count                 = count' bool
instance RBin' Bool where
    showbin               = showBin' bool
instance RCount a => RCount [a] where
    count                 =  count' (list overCount)
instance GenericList Count where
    list a = Count (\l -> 1 + count' (rList a) l)

showBinString = showBin' (list (ShowBin showBinCharBE))

showBinCharBE = showBinChar

data BTree a b = BLeaf a | BFork b (BTree a b) (BTree a b) deriving Show

instance RCount a => RCount (BTree a b) where
    count                  = count' (btree overCount (Count (const 0)))

countBTree :: (RCount a, RCount b) => BTree a b -> Int
countBTree = count' (btree overCount (Count (const 1)))

btree ra rb = rtype isoBTree ( rcon (ConDescr "BLeaf" 1 False Prefix) ra <|>
                               rcon (ConDescr "BFork" 3 False Prefix) (rb <*> btree ra rb <*> btree ra rb))

isoBTree = EP fromBTree toBTree

fromBTree (BLeaf x)                 = L x
fromBTree (BFork x r l)             = R (x :*: (r :*: l))

toBTree (L x)                     = BLeaf x
toBTree (R (x :*: (r :*: l)))     = BFork x r l

testBTree :: BTree Integer Int
testBTree = BFork 3 (BLeaf 2) (BFork 4 (BLeaf 5) (BLeaf 6))

instance RCount Integer where
    count = const 1

t1 :: BTree Int Int
t1 = BFork 5 (BFork 3 (BLeaf 2) (BLeaf 4)) (BLeaf 6)

line                          :: Doc
line                          =  nl

prettyChar                    :: Char -> Doc
prettyChar                    =  Prettier.pretty

prettyString                  :: String -> Doc
prettyString                  =  Prettier.pretty

prettyInt                     :: Int -> Doc
prettyInt                     =  Prettier.int

render                        :: Int -> Doc -> IO ()
render n d                    =  putStrLn (Prettier.render (Page n) d)

{-
pretty                        :: (TypeRep a) => a -> Doc
pretty                        =  pretty' typeRep
-}

atree :: Tree Int
atree = Fork 2 (Fork 0 Empty 4 Empty) 5 (Fork 1 (Fork 0 Empty 3 Empty) 7 (Fork 0 Empty 3 Empty))

t :: Tree Char
t =  Fork 1 (Fork 0 Empty 'h' Empty) 'i' (Fork 0 Empty '!' Empty)

newtype Pretty a               =  Pretty { pretty' :: a -> Doc }

instance Generic Pretty where
  runit                        =  Pretty (const Prettier.empty)
  rchar                        =  Pretty (prettyChar)
  rint                         =  Pretty (prettyInt)
  rsum a b                     =  Pretty (\ x ->  case x of  L l  ->  pretty' a l
                                                             R r  ->  pretty' b r)
  rprod a b                    =  Pretty (\ (x :*: y) ->  pretty' a x <> line <> pretty' b y)
  rtype ep a                   =  Pretty (pretty' a . from ep)
  rcon cd a                    =  Pretty (prettyConstr cd a)
  rfloat                       =  error "not implemented"
  rinteger                     =  error "not implemented"
  rdouble                      =  error "not implemented"

prettyConstr (ConDescr n ar _ _) a x = let s = text n in
    if ar == 0 then s
    else group (nest 1 (text "("  <> s <> line <> pretty' a x <> text ")" ))

data Tree a = Empty | Fork Int (Tree a) a (Tree a)

class Generic g => GenericTree g where
  tree :: g a -> g (Tree a)
  tree a = rtype isoTree ( rcon  (ConDescr "Empty" 0 False Prefix) runit `rsum`
                           rcon  (ConDescr "Fork"  4 False Prefix) (rint `rprod` (  rTree a `rprod`
                                                                      (a `rprod` rTree a))))

instance GenericTree Pretty

rTree           :: Generic g => g a -> g (Tree a)
rTree a         =  rtype isoTree ( rcon  (ConDescr "Empty" 0 False Prefix) runit <|>
                                   rcon  (ConDescr "Fork"  4 False Prefix) (rint <*> rTree a <*> a <*> rTree a))

class RPretty a where
    pretty                 :: a -> Doc
    prettyList             :: [a] -> Doc
    prettyList             =  pretty' (list oPretty)
instance RPretty Unit where
    pretty                 =  pretty' oPretty
instance RPretty Char where
    pretty                 =  pretty' rchar
    prettyList             =  prettyString
instance RPretty Int where
    pretty                 =  pretty' rint
instance (RPretty a, RPretty b) => RPretty (a :+: b) where
    pretty                 =  pretty' (rsum oPretty oPretty)
instance (RPretty a, RPretty b) => RPretty (a :*: b) where
    pretty                 =  pretty' (rprod oPretty oPretty)
instance RPretty a => RPretty (Tree a) where
    pretty                 =  pretty' (tree oPretty)

oPretty :: RPretty t => Pretty t
oPretty = Pretty pretty

instance GenericList Pretty where
   list p = Pretty (\x ->
     case x of  []      -> text "[]"
                (a:as)  -> group (nest 1 (text "[" <> pretty' p a <> rest as)))
     where  rest []              =  text "]"
            rest (x : xs)        =  text "," <> line <> pretty' p x <> rest xs

instance RPretty a => RPretty [a] where
    pretty                 = prettyList

data Pretty1 a = Pretty1 {  pretty1      :: a -> Doc,
                            prettyList1  :: [a] -> Doc}

showBinChar                   :: Char -> [Bit]
showBinChar i                 =  showBinIntegral 7 (fromEnum i)       -- HACK

showBinInt                    :: Int -> [Bit]
showBinInt i                  =  showBinIntegral 16 (fromEnum i)       -- HACK

showBinIntegral               :: (Integral a) => Int -> a -> [Bit]
showBinIntegral 0 _n          =  []
showBinIntegral m  n
    | r == 0                  =  O : showBinIntegral k q
    | otherwise               =  I : showBinIntegral k q
    where (q, r)              =  divMod n 2
          k                   =  m - 1

{-
class RBin t where
    showBin                    :: t -> [Bit]
    showBin {| Unit |}         = showBin' unit
    showBin {| a :+: b |}      = showBin' (plus overBin overBin)
    showBin {| a :*: b |}      = showBin' (prod overBin overBin)
instance RBin Int where
    showBin                    = showBin' int
instance RBin Char where
    showBin                    = showBin' char

overBin :: RBin a => ShowBin a
overBin = ShowBin showBin
-}

data OddList a    = OValue a | OCons a (EvenList a)

data EvenList a   = ENil | ECons a (OddList a)

data PTree a      = PEmpty | PFork a (PTree (a,a))

{-
instance RBin a => RBin (OddList a)
instance RBin a => RBin (EvenList a)
instance RBin a => RBin (PTree a)
instance (RBin a, RBin b) => RBin (a,b)
-}

class GRep g t where
   over :: g t

instance Generic g => GRep g Unit where
   over = runit
instance Generic g => GRep g Int where
   over = rint
instance Generic g => GRep g Char where
   over = rchar
instance Generic g => GRep g Float where
   over = rfloat
instance (Generic g, GRep g a, GRep g b) => GRep g (a :+: b) where
   over = rsum over over
instance (Generic g, GRep g a, GRep g b) => GRep g (a :*: b) where
   over = rprod over over
instance (GenericList g, GRep g a) => GRep g [a] where
   over = list over
instance (GenericTree g, GRep g a) => GRep g (Tree a) where
   over = tree over

showBin1 :: GRep ShowBin t => t -> [Bit]
showBin1 = showBin' over

pretty2 :: GRep Pretty t => t -> Doc
pretty2 = pretty' over
