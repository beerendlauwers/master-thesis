module Main where

main = print $ conc' [1 .. 1000000] [1 .. 1000000]

conc' = foldl (\k x -> k . (x:)) id