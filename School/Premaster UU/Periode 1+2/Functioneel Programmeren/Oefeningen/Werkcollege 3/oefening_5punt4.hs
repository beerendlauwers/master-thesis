telRegels :: IO Int
telRegels = do
              naam <- getLine
              bestandInhoud <- readFile naam
              return ( length ( splitOn '\n' bestandInhoud ) )


splitOn :: Char -> String -> [String]
splitOn delimiter [] = [""]
splitOn delimiter (l:ls) = if l == delimiter
                           then "" : rest
                           else (l : head rest) : tail rest 
                           where rest = splitOn delimiter ls