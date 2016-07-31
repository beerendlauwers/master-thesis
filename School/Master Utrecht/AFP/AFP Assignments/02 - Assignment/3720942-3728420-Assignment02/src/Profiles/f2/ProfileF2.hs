module Main where

f2 = if length [1 .. 1000000] > 0 then head [1 .. 1000000] else 0

main = print f2