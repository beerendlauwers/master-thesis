module Main where

rev' = foldr (\x r -> r ++ [x]) []

main = print $ rev' [1 .. 50000]