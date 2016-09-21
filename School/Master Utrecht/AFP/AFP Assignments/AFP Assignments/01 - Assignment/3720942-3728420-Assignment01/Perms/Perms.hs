module Perms.Perms where

import Data.List

-- Code from the assignment PDF:

split []     = []
split (x:xs) = (x,xs):[(y,x:ys) | (y,ys) <- split xs]

perms [] = [[]]
perms xs = [(v:p) | (v,vs) <- split xs, p <- perms vs]

smooth n (x:y:ys) = abs (y - x) <= n && smooth n (y:ys)
smooth _ _        = True

smooth_perms :: Int -> [Int] -> [[Int]]
smooth_perms n xs = filter (smooth n) (perms xs)

-- Exercise 2:
-- Addition

-- | Tree structure for our representation of permutations.
data Tree a = Node a [Tree a]
            | Leaf
            deriving (Show, Ord, Eq)

-- | 'smooth_perms_tree' implements the same as 'smooth_perms' but using a prunned tree to speed up the permutation checking.
smooth_perms_tree :: Int -> [Int] -> [[Int]]
smooth_perms_tree n = fromTrees . (map (pruneTree n)) . toTrees

-- | 'toTrees' converts a list into a list of Trees containing all the permutation possibilities.
-- Each tree starts with one element of the list.
toTrees :: (Num a) => [a] -> [Tree a]
toTrees [] = [Leaf]
toTrees xs = map (\y -> Node y (toTrees $ delete y xs)) xs

-- | 'fromTrees' converts a list of trees into the list of all the permutations represented by all the trees.
fromTrees :: (Num a) => [Tree a] -> [[a]]
fromTrees (x:xs) = filter (not . null) $ fromTree x ++ fromTrees xs
fromTrees []     = []

-- | 'fromTree' converts a tree into all the permutations it represents.
fromTree :: (Num a) => Tree a -> [[a]]
fromTree (Node x []) = [[x]]
fromTree (Node x ts) = [(x:ys) | t <- ts, ys <- fromTree t]
fromTree Leaf        = [[]]

-- | 'pruneTree' prunes the tree by cutting off branches that do not respect the smoothness property as parametrized.
pruneTree :: (Eq a, Ord a, Num a) => a -> Tree a -> Tree a
pruneTree n (Node x []) = Node x []
pruneTree n Leaf        = Leaf
pruneTree n (Node x ts) = let ls = filter (treeFilter n x) ts
                          in if null ls && not (null ts)
                             then Leaf
                             else Node x $ map (pruneTree n) ls

-- | 'treeFilter' is a helper function to check if any of the branches in a certain tree is smooth.
treeFilter :: (Eq a, Ord a, Num a) => a -> a -> Tree a -> Bool
treeFilter n x (Node y ys) = abs(x-y) <= n && any (treeFilter n y) ys
treeFilter _ _ Leaf        = True