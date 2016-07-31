module Main where

main = print $ conc [1 .. 1000000] [1 .. 1000000]

conc xs ys = foldr (:) ys xs
