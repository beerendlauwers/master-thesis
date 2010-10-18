binaryAdd :: [Int] -> [Int] -> [Int]
binaryAdd [] [] = []
binaryAdd (x:xs) (y:ys) = getResult
                        where getResult | x == 1 && y == 1 = 0 : rest xs ys
                                        | x == 1 || y == 1 = 1 : binaryAdd xs ys
                                        | x == 0 && y == 0 = 0 : binaryAdd xs ys
                              rest (a:as) (b:bs)  = 
                                      if length (a:as) == 0 && length (b:bs) == 0
                                        then [1]
                                        else if length (a:as) > 1 && length (b:bs) > 1
                                               then if a == 0 || b == 0
                                                     then if b == 0 
                                                           then binaryAdd (a:as) ( 1 : bs )
                                                           else binaryAdd ( 1 : as ) (b:bs)
                                                     else 1 : rest as bs
                                               else if a == 0
                                                     then if b == 0
                                                           then binaryAdd (a:as) [1]
                                                           else binaryAdd [1] (b:bs)
                                                     else 1 : binaryAdd [0] [1]
                                                     
                                                     -- werkt niet goed voor grotere getallen! :(