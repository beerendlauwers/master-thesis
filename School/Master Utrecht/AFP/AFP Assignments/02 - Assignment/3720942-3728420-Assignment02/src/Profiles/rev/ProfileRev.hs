module Main where

rev = foldl (flip (:)) []

main = print $ rev [1 .. 100000]