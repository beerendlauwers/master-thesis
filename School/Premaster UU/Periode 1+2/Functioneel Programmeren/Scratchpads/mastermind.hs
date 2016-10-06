module Main where

import System.Random  -- for randoms
import System.IO      -- for hFlush

type Row = [Int]
type Guess = Row
type Solution = Row

colors = 6
width  = 4

-- A function that indicates places on which you have to work:
tODO :: a -> a
tODO = id

-- This is the complete main function. It just initializes the
-- game by generating a solution and then calls the game loop.
main :: IO ()
main =
  do
    s <- generateSolution -- initialization
    loop s                -- game loop

-- The following function is given. It generates a random solution of the
-- given width, and using the given number of colors.
generateSolution =
  do
    g <- getStdGen
    let rs = take width (randoms g)
    return (map ((+1) . (`mod` colors)) rs)

-- The loop function is supposed to perform a single interaction. It
-- reads an input, compares it with the solution, produces output to
-- the user, and if the guess of the player was incorrect, loops.
loop :: Solution -> IO ()
loop solution =
  do
    guess <- input            -- read (and parse) the user input
    let checkedInput = check solution guess
    report checkedInput
    --putStrLn feedback
    --loop solution
    tODO (return ())

lst3 :: (a,b,c) -> c
lst3 (_,_,c) = c

black, white :: Solution -> Guess -> Int

black [] [] = 0
black solution guess = if (take 1 solution) == (take 1 guess) then 1 + nextGuess else nextGuess
                       where nextGuess = black (drop 1 solution) (drop 1 guess)
					   
					   
--getPos :: Int -> Row -> Int
--getPos x y = if calculatePos == length y then -1 else calculatePos
--             where calculatePos = length( takeWhile (\n -> x /= n) y )

--checkListEqual :: Row -> Row -> Int
--checkListEqual [] [] = 0
--checkListEqual (x:xs) (y:ys) = if x == y then 1 + nextCheck else nextCheck
--                          where nextCheck = checkListEqual xs ys

removeNumbersOnSamePosition :: Row -> Row -> Row
removeNumbersOnSamePosition [] [] = []
removeNumbersOnSamePosition (x:xs) [] = []
removeNumbersOnSamePosition (x:xs) (y:ys) = if x == y
                                            then removeNumbersOnSamePosition xs ys
											else x : removeNumbersOnSamePosition xs ys
					   
--comparePos :: Row -> Row -> Row
--comparePos solution guess = map (\n -> getPos n solution) guess

--solveWhite :: Solution -> Guess -> Int
--solveWhite solution [] = 0
--solveWhite solution guess = if elem (head guess) solution
--							  then 1 + nextGuess
--							  else nextGuess
--						      where nextGuess = solveWhite solution (drop 1 guess)

--white solution guess = solveWhite (removeNumbersOnSamePosition solution guess) (removeNumbersOnSamePosition guess solution)


white solution guess = let solveWhite shortSolution shortGuess = if shortGuess == []
                                                         then 0
														 else if elem (head shortGuess) shortSolution
														 then 1 + nextGuess
														 else nextGuess
														 where nextGuess = solveWhite shortSolution (drop 1 shortGuess)
					   in solveWhite (removeNumbersOnSamePosition solution guess) (removeNumbersOnSamePosition guess solution)
					   
check :: Solution -> Guess -> (Int,   -- number of black points,
                               Int,   -- number of white points
                               Bool)  -- all-correct guess?
check solution guess = (checkBlack,
                        checkWhite,
                        if checkBlack == 4 && checkWhite == 0 then True else False)
						where checkBlack = black solution guess; checkWhite = white solution guess

-- report is supposed to take the result of calling check, and
-- produces a descriptive string to report to the player.
report :: (Int, Int, Bool) -> IO()
report (black, white, correct) = let showResults = show black ++ " black, " ++ show white ++ " white"
                                 in if black == 4
								    then putStrLn (showResults ++ "\nCongratulations!")
									else putStrLn showResults

-- The function input is supposed to read a single guess from the
-- player. The first three instructions read a line. You're supposed
-- to (primitively) parse that line into a sequence of integers.
input :: IO Guess
input =
  do
    putStr "? "
    hFlush stdout -- ensure that the prompt is printed
    l <- getLine
    let filteredNumbers = words l
    return (map readInt filteredNumbers)
    --tODO (return [])

-- The following function |readInt| is given and parses a single
-- integer from a string. It produces |-1| if the parse fails. You
-- can use it in |input|.
readInt :: String -> Int
readInt x =
  case reads x of
    [(n, "")] -> n
    _         -> -1

-- The function valid tests a guess for validity. This is a bonus
-- exercise, so you do not have to implement this function.
valid :: Guess -> Bool
valid guess = tODO True