main :: IO ()
main = do
   putStrLn "Neem een getal tussen 1 en 100 (inclusief) in gedachten"
   raad 1 100 []

raad :: Int -> Int -> [Int] -> IO ()
raad onder boven anticheatlijst = do
   putStrLn ("Is het " ++ show midden ++ "? (g = groter, k = kleiner, j = ja)")
   putStrLn (show anticheatlijst)
   antwoord <- getLine
   if elem midden anticheatlijst then putStrLn "OH NEE VALSGESPEELD" else 
     verwerkAntwoord antwoord
     where
       verwerkAntwoord :: String -> IO ()
       verwerkAntwoord "g" = raad (midden + 1) boven (midden : anticheatlijst)
       verwerkAntwoord "k" = raad onder (midden - 1) (midden : anticheatlijst)
       verwerkAntwoord "j" = putStrLn "Geraden!"
       verwerkAntwoord _ = raad onder boven anticheatlijst

       midden :: Int
       midden = (onder + boven) `div` 2