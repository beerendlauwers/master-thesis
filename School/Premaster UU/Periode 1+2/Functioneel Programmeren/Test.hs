module Test where

vijf :: Int
vijf = 2 + 3

fac :: Int -> Int
fac n | n == 0 = 1
      | n > 0 = n * fac (n - 1)

-- XOR functie

xor :: Bool -> Bool -> Bool
xor b1 b2 | b1 == b2 = False
          | b1 /= b2 = True

impl :: Bool -> Bool -> Bool
impl p q | q == False && p == True = False
	| q == False && p == False = True
	| q == True && p == False = True
	| q == True && p == True = True

-- Geeft laatste item van een lijst

laatste :: [a] -> a
laatste [] = error "Empty list!"
laatste x = head (reverse x)

-- Geeft alleen even elementen weer, werkt enkel met Ints

alleenEven :: [Int] -> [Int]
alleenEven lijst = filter even lijst