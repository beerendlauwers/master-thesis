main :: IO ()
main = do
   putStrLn "Neem een getal tussen 1 en 100 (inclusief) in gedachten"
   raad 1 100 [1..100]

raad :: Int -> Int -> [Int] -> IO ()
raad onder boven anticheatlijst = do
   putStrLn ("Is het " ++ show midden ++ "? (g = groter, k = kleiner, j = ja)")
   antwoord <- getLine
   if not (elem midden anticheatlijst) then putStrLn "OH NEE VALSGESPEELD" else 
     verwerkAntwoord antwoord
     where
       verwerkAntwoord :: String -> IO ()
       verwerkAntwoord "g" = raad (midden + 1) boven (antiCheat "g")
       verwerkAntwoord "k" = raad onder (midden - 1) (antiCheat "k")
       verwerkAntwoord "j" = putStrLn "Geraden!"
       verwerkAntwoord _ = raad onder boven anticheatlijst

       antiCheat :: String -> [Int]
       antiCheat "g" = takeBetween midden (maximum anticheatlijst) anticheatlijst
       antiCheat "k" = takeBetween (minimum anticheatlijst) midden anticheatlijst

       midden :: Int
       midden = (onder + boven) `div` 2

takeBetween :: Int -> Int -> [Int] -> [Int]
--dropBetween begin eind (x:xs) = if begin >= x then dropBetween xs else 
takeBetween begin eind lijst = filter (\n -> n >= begin && n <= eind ) lijst