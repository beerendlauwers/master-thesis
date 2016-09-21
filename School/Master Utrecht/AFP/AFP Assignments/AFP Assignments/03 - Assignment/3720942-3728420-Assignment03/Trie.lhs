%include lhs2TeX.fmt
\begin{code}
module Trie where

import qualified Data.Map as M

data Trie a = Node (Maybe a) (M.Map Char (Trie a)) deriving (Show, Eq)

empty :: Trie a
empty = Node Nothing M.empty

null :: (Eq a) => Trie a -> Bool
null = (==) empty

valid :: Trie a -> Bool
valid (Node a m) = case a of
                        Nothing -> if M.null m then True else validLeafs' m
                        otherwise -> validLeafs' m
                   where validLeafs' = M.fold (\t a -> validLeafs t && a) True
\end{code}

Checks if any leaf node is present without any value.
The idea is that if true, that means we're at a Node with Nothing for (Maybe a) but one empty node at one point in the subtrie.

\begin{code}
validLeafs :: Trie a -> Bool
validLeafs (Node Nothing m) | M.null m = False
validLeafs (Node _       m) = M.fold (\t a -> validLeafs t && a) True m

insert :: String -> a -> Trie a -> Trie a
insert (x:xs) a (Node b m) = Node b $ M.insertWithKey f x (insert xs a empty) m
                             where f k n o = insert xs a o
insert []     a (Node _ m) = Node (Just a) m

lookup :: String -> Trie a -> Maybe a
lookup (x:xs) (Node _ m) = do m' <- M.lookup x m
                              r  <- Trie.lookup xs m'
                              return r
lookup []     (Node a _) = a

delete :: (Eq a) => String -> Trie a -> Trie a
delete (x:xs) (Node a m) = Node a $ M.filter (not . Trie.null)
				  $ M.adjust (delete xs) x m
delete []     (Node _ m) = Node Nothing m
\end{code}

\subsection*{Examples}

Examples to test the functions above.
Example 4 gives us exactly what is on the PDF.

\begin{code}
example1 = insert "f" 0 Trie.empty 
example2 = insert "foo" 1 example1
example3 = insert "bar" 2 example2
example4 = insert "baz" 3 example3
\end{code}
