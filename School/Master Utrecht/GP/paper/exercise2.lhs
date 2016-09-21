> import Data.Generics.Multiplate
> import Data.Functor.Constant
> import Data.Functor.Identity
> import Control.Applicative

Be sure to install the multiplate library.

Define a multiplate instance for the mutually recursive datatypes Zig and Zag 
Then, define a generic function 'collectCharsInts' that returns a tuple of two lists:
one with all Zig Chars and one with all Zag Ints.

Example use:
Main> collectCharsInts ZigCons 'a' (ZagCons 5 (ZigCons 'b' (ZagCons 10 (ZigEnd 'c'))))
("abc",[5,10])

(Also allowed: ("cba",[10,5]) )

> data Zig = ZigEnd Char | ZigCons Char Zag deriving Show
> data Zag = ZagEnd Int | ZagCons Int Zig deriving Show

Solution:

> data Plate f = Plate { zig :: Zig -> f Zig, zag :: Zag -> f Zag }

> instance Multiplate Plate where
>  multiplate child = Plate buildZig buildZag
>   where
>    buildZig (ZigEnd x) = ZigEnd <$> pure x
>    buildZig (ZigCons x xs) = ZigCons <$> pure x <*> zag child xs
>    buildZag (ZagEnd x) = ZagEnd <$> pure x
>    buildZag (ZagCons x xs) = ZagCons <$> pure x <*> zig child xs
>  mkPlate build = Plate (build zig) (build zag)

> type Collection = ([Char],[Int])

> collectDataPlate :: Plate (Constant Collection)
> collectDataPlate = Plate { zig = collectZigs, zag = collectZags }
>   where
>    collectZigs (ZigEnd x) = Constant ([x],[])
>    collectZigs (ZigCons x xs) = Constant ([x],[]) <*> pure xs
>    collectZags (ZagEnd x) = Constant ([],[x])
>    collectZags (ZagCons x xs) = Constant ([],[x]) <*> pure xs

> collectData = preorderFold collectDataPlate

> value1 = ZigCons 'a' (ZagCons 5 (ZigCons 'b' (ZagCons 10 (ZigEnd 'c'))))

> collectCharsInts = foldFor zig collectData