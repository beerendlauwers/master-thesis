second x = baseconvert $ drop 4 x
first x  = baseconvert $ take 4 x
toHex x = first x : second x :[]

baseconvert x = case x of
                  "0000" -> '0'
                  "0001" -> '1'
                  "0010" -> '2'
                  "0011" -> '3'
                  "0100" -> '4'
                  "0101" -> '5'
                  "0110" -> '6'
                  "0111" -> '7'
                  "1000" -> '8'
                  "1001" -> '9'
                  "1010" -> 'a'
                  "1011" -> 'b'
                  "1100" -> 'c'
                  "1101" -> 'd'
                  "1110" -> 'e'
                  "1111" -> 'f'
                  
convertList = map toHex