module Main where

f1 = let xs = [1 .. 1000000] in if length xs > 0 then head [1 .. 1000000] else 0

main = print f1