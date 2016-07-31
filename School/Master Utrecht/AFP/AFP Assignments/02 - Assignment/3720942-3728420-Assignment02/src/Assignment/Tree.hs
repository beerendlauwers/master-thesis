module Assignment.Tree where

import Prelude hiding (iterate, map)
import Data.List hiding (map)

-- | Tree data type
data Tree a = Leaf a
            | Node (Tree a) (Tree a)
              deriving Show

-- | 'unfold' for the Tree datatype.
unfoldTree :: (s -> Either a (s, s)) -> s -> Tree a
unfoldTree next x =
    case next x of
     Left  y      -> Leaf y
     Right (l, r) -> Node (unfoldTree next l) (unfoldTree next r)

iterate :: (a -> a) -> a -> [a]
iterate f = unfoldr (\x -> Just (x, f x))

map :: (a -> b) -> [a] -> [b]
map f list = unfoldr mapElements list
 where
    mapElements (x:xs) = Just (f x, xs)
    mapElements []     = Nothing

-- | Generates a balanced tree of the given height.
balanced :: Int -> Tree ()
balanced n = unfoldTree next n
             where next 1 = Left ()
                   next n = Right (n-1, n-1)

-- | Generates any tree with the given number of nodes.
-- Each leaf should have a unique label.
sized :: Int -> Tree Int
sized n = unfoldTree next (False, n)
          where next (True, n)  = Left n
                next (False, 0) = Left 0
                next (False, n) = Right ((True, n), (False, n-1))