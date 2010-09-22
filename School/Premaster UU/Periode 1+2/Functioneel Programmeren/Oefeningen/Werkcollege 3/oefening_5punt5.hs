telRegels :: IO ()
telRegels = do
              naam <- getLine
              bestandInhoud <- readFile naam
              let gesplitsteInhoud =  splitOn '\n' bestandInhoud
              putStrLn ( show (length gesplitsteInhoud ) )
              putStrLn ( show (length (splitOn ' ' (flattenMetSpaties gesplitsteInhoud) ) ) )

flattenMetSpaties :: [String] -> String
flattenMetSpaties [] = []
flattenMetSpaties (x:xs) = x ++ " " ++ flattenMetSpaties xs
flattenMetSpaties (x:[]) = if xs == [] then x ++ flattenMetSpaties xs else x ++ " " ++ flattenMetSpaties xs

splitOn :: Char -> String -> [String]
splitOn delimiter [] = [""]
splitOn delimiter (l:ls) = if l == delimiter
                           then "" : rest
                           else (l : head rest) : tail rest 
                           where rest = splitOn delimiter ls