sequencehabl :: [IO a] -> IO [a]
sequencehabl (x:xs) = do s <- x
                         ss <- sequencehabl xs
                         return (s:ss)