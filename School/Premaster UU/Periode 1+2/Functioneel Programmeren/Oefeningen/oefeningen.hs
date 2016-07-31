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

