module Main where

f1 = let xs = [1 .. 1000000] in if length xs > 0 then head xs else 0

main = print f1