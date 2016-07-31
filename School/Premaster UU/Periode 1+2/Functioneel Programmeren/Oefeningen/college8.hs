data Boom a = Blad a
             | Tak (Boom a) (Boom a)
             deriving (Show)

--8.8
mapBoom :: (a -> b) -> Boom a -> Boom b
mapBoom f (Blad x) = Blad (f x)
mapBoom f (Tak links rechts) = Tak (mapBoom f links) (mapBoom f rechts)

foldBoom :: (b -> b -> b) -> (a -> b) -> Boom a -> b
foldBoom op e (Blad x) = e x
foldBoom op e (Tak links rechts) = (foldBoom op e links) `op` (foldBoom op e rechts)

--8.9
diepteBoom :: Boom a -> Int
diepteBoom (Blad x) = 1
diepteBoom (Tak links rechts) = 1 + max (diepteBoom links) (diepteBoom rechts)

--diepteBoom' :: Boom a -> Int
--diepteBoom' deboom = foldBoom 
--diepteBoom' (Blad x) = 1
--diepteBoom' (Tak links rechts) = mapBoom a

--8.10
toonBoom :: Show a => Int -> Boom a -> String
toonBoom insprong (Blad x) = "\n" ++ (maakInsprong insprong) ++ show x
toonBoom insprong (Tak links rechts) = "\n" ++ (maakInsprong insprong) ++ "*" ++ "\n" ++ (maakInsprong (insprong - 1)) ++ "/ \\" ++ (toonBoom insprong links) ++ " " ++ (toonBoom (insprong + 2) rechts)

maakInsprong 0 = ""
maakInsprong x = " " ++ maakInsprong (x-1)

--8.11
-- min: 
--  n (want we splitsesn per diepte steeds tweemaal op)
-- max: (2^n-1)

data Zoekboom a = Tak a (Zoekboom a) a (Zoekboom a)
                | Zoekblad

--8.12
insertInBoom :: e -> Boom a -> Boom a
insertInBoom e Blad = Tak e Blad Blad
insertInBoom e (Tak x links rechts) | e <= x = Tak x (insertInBoom e links) rechts
                                    | e > x  = Tak x links (insertInBoom e rechts)

lijstNaarBoom lijst = lijstNaarBoom laag lijstNaarBoom hoog
		      laag = take (half lijst)
		      hoog = drop (half lijst)
		      half = (length lijst) / 2




test = Tak (Blad 2) (Tak (Blad 3) (Blad 5))
-- 2 + ( 3 + 5 ) 