
-- Opgave 1

flatten :: [[a]] -> [a]
flatten [] = []
flatten (x:xs) = x ++ flatten(xs)

-- Opgave 3

--insert :: Int -> [Int] -> [Int]
--insert x [] = []
--insert x (y:ys) | x <= y = x : (y : ys)
--				| x > y = insert x ys
				
insert :: Int -> [Int] -> [Int]
insert x [] = []
--insert x (y:ys) = if x <= y then x : (y : ys) else insert x ys

--insert x (y:ys) = if x > y && null (head ys) /= True && x < head ys then [y,x] ++ ys else insert x [y :

insert x (y:ys) = filter (\n -> x >= n) (y : ys) ++ x : filter (\n -> x <= n) (y : ys)

--insert x (y:ys) | x >= y = takeWhile (\n -> x >= y) (y : ys) ++ x : takeWhile (\n -> x < y) (y : ys)

-- Opgave 4

sort :: [Int] -> [Int]
sort [] = []
--sort (x:xs) = sort ( filter (\n -> x <= n) xs ++ x : filter (\n -> x >= n) xs )

--sort (x:xs) | all (\n -> x <= n) (x : xs) = x : sort xs
--			| all (\n -> x >= n) (x : xs) = sort xs ++ [x]
			
--sort (x:xs) = if x >= head xs then [head xs, x] ++ sort (drop 1 xs) else [x, head xs] ++ sort (drop 1 xs)

--sort (x:xs) = insert x xs

-- Opgave 5

flatten' :: [[a]] -> [a]
--flatten' (x:xs) = x ++ flatten(xs)
flatten' = foldr (++) []

-- Opgave 6
sort' :: [Int] -> [Int]
sort' = foldr () []

