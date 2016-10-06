import Data.List
import Data.Char

-- 1

unwords' :: [String] -> String
unwords' [x] = x
unwords' (x:xs) = x ++ " " ++ unwords' xs

unwords'' :: [String] -> String
unwords'' list = foldr (++) [] (intersperse " " list)

words' :: String -> [String]
words' [] = []
words' list = let (first,second) = split [] list
              in (reverse first) : words' second

split param [] = (param,[])
split param (x:xs) = if x == ' ' then (param,xs)
                                 else split (x:param) xs
                                 
-- 2
-- type foldr = (a -> b -> b) -> b -> [a] -> b
-- type foldl = (a -> b -> a) -> a -> [b] -> a
-- def. foldr = foldr op e (x:xs) = x `op` foldr op e xs
-- def. foldl = foldl op (e `op` x) xs

-- 3
-- 0 nr 1 nr 2 nr 3 = 123
naarGetal :: [Int] -> Int
naarGetal = foldl nr 0
            where nr n rest = 10*n + rest
               
stringNaarGetal :: String -> Int
stringNaarGetal = naarGetal . map (\x -> ord x - 48)

-- 4
data Tree a = Bin (Tree a) (Tree a) | Tip a deriving (Show)
testTree = Bin ( Bin ( Bin (Tip 3) (Tip 5) ) (Bin (Tip 9) (Tip 8) ) ) (Tip 7)

gegevens :: Tree a -> [a]
gegevens (Bin x y) = gegevens x ++ gegevens y
gegevens (Tip x) = [x]

-- 5
inpakken :: Tree Integer -> String
inpakken (Bin x y) = "(" ++ inpakken x ++ "),(" ++ inpakken y ++ ")"
inpakken (Tip x) = show x

-- 6
zoekElem nr rest [] = reverse rest
zoekElem nr rest (x:xs) = if nr == -1
                           then (head rest:x:xs)
                           else zoekRest
                          where             
                           zoekRest | x == '(' = zoekElem (nr+1) [x] xs
                                    | x == ')' = zoekElem (nr-1) [x] xs
                                    | otherwise = zoekElem nr (x:rest) xs
