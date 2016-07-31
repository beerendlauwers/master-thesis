-- 7.1
inits [ ] = [[ ]]
inits (x : xs) = [ ] : map (x :) (inits xs)

segs [] = [[]]
segs (x : xs) = tail (inits (x : xs)) ++ segs xs

-- 7.2
tails [ ] = [[ ]]
tails (x : xs) = (x : xs) : tails xs


-- Om exact juiste uitkomst te krijgen moeten we nog ERGENS init uitvoeren om de lege lijsten vqn tails weg te krijgen
segs2 [] = [[]]
segs2 (x : xs) = map  tails (tail (inits (x : xs)) )


-- 7.3
-- inits xs : n + 1
-- segs xs: som ( summatie van i=0 tot n, waarbij i = n - i ) + 1

--i = n - i
-- voorbeeld: (1,2,3,4) --> resultaat: (4,3,2,1)
-- (i begint vanaf 0)

-- subs xs: som ( summatie van i=1 tot n, waarbij i = 2^(n - i) ) + 1

--i = 2^(n - i)
-- voorbeeld (1,2,3,4) --> resultaat: (8,4,2,1)
-- ( i begint hier vanaf 1)

-- perms xs: !n (factor n)
combs 0 xs = [[]]
combs (n + 1) [] = []
combs (n + 1) (x : xs) = map (x:) (combs n xs) ++ combs (n + 1) xs

-- combs xs: 

-- 7.4
-- NOG DOEN: TEKEN DIT EENS UIT
initsfoldr :: [a] -> [[a]]
initsfolder [] = [[]]
initsfoldr xs = foldr (\x r -> [] : map (x :)  r) [[]] xs

-- 7.5
-- Omdat tails langs de linkerkant elementen afbreekt.

-- 7.6
-- Nog te maken!
--segsfoldr [] = [[]]
--segsfoldr xs = foldr (\x r -> ) [[]] xs

--7.7
bins :: Int -> [String]
bins 0 = [[]]
--bins x = 

--7.8
removeItem _ []                 = []
removeItem x (y:ys) | x == y    = removeItem x ys
                    | otherwise = y : removeItem x ys

gaps :: Eq a => [a] -> [[a]]
gaps [] = [[]]
gaps lijst = map (\n -> removeItem n lijst) lijst
















--bins n = [x:xs | x <- ['0','1'] , xs <- bins (n-1) ]