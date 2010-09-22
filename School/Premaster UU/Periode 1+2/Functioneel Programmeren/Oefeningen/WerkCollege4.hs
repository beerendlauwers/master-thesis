-- 6.1
last' :: [a] -> a
--last' x = head (reverse x)
last' = head . reverse

--6.2
eenna :: [a] -> a
eenna x = head (drop 1 (reverse x) )

--6.3
ide :: [a] -> Int -> a
ide (x:xs) i = if i == 0 then x else ide xs (i-1)

--6.4
aantal :: [a] -> Int
aantal [] = 0
aantal (x:xs) = 1 + aantal (xs)

--6.5
omdraai :: [a] -> [a]
omdraai [] = []
omdraai (x:xs) = omdraai xs ++ [x]

--6.6
palindroom :: Eq a => [a] -> Bool
palindroom [] = True
palindroom x = if x == (reverse x) then True else False

--6.7
slaplat :: [[a]] -> [a]
slaplat [] = []
slaplat (x:xs) = x ++ slaplat xs

--6.8
wegdup :: Eq a => [a] -> [a]
wegdup [] = []
wegdup (x:ys) = if length ys == 0 then [x]
                                 else if x == head ys
                                      then wegdup ys
                                      else x : wegdup ys

--6.9
vulop :: Eq a => [a] -> [[a]]
vulop [] = []
vulop (x:xs) = leesCijfers (x:xs) : vulop (drop (length (leesCijfers xs) ) xs)
               where leesCijfers = takeWhile (\n -> n == x)

--6.10
runlength :: Eq a => [a] -> [(Int,a)]
runlength [] = []
runlength (x:xs) = ( length (telCijfers (x:xs) ), x ) : runlength (drop (length (telCijfers xs) ) xs)
                   where telCijfers = takeWhile (\n -> n == x)

--6.12
concatfoldr :: [a] -> [a] -> [a]
concatfoldr x y = foldr (:) y x

--6.14
filterconconcat :: (a -> Bool) -> [a] -> [a]
filterconconcat p = concat . map box
                  where box x = (\n -> if p n == True then [n] else []) x
                  
--6.15
repeatiterate :: Num a => a -> [a] 
repeatiterate x = iterate (*1) x

--6.16
removedoubles :: Eq a => [a] -> [a] -> [a]
removedoubles [] [] = []
removedoubles [] (y:ys) = []
removedoubles (x:xs) [] = (x:xs)
removedoubles (x:xs) (y:ys) = if elem y (x:xs) && x == y
                              then removedoubles xs ys
                              else if elem y (x:xs)
                                   then x : removedoubles xs (y:ys)
                                   else x : removedoubles xs ys
                                   
--6.18
qEq :: Ord a => a -> a -> Bool
qEq x y | x > y = False
        | x < y = False
        | otherwise = True
