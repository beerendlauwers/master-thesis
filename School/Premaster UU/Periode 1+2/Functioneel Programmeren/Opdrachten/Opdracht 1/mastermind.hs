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
    loop s 0              -- game loop

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
loop :: Solution -> Int -> IO ()
loop solution guesscount =
  do
    guess <- input            -- read (and parse) the user input
    processGuess guess
  where
   processGuess :: Solution -> IO ()
   processGuess [-50] = putStrLn ("The solution was: " ++ show solution ++ "\nBetter luck next time.\nYou guessed " ++ show guesscount ++ " time(s).")
   processGuess [-60] = putStrLn ("The solution was: " ++ show solution ++ "\nCome back soon!\nYou guessed " ++ show guesscount ++ " time(s).")
   processGuess guess = do
            let checkedInput = check solution guess
            report checkedInput
            if lst3 checkedInput == False then loop solution (guesscount + 1) else putStrLn ("\nYou guessed " ++ show guesscount ++ " time(s).")

-- Takes the last element of a 3-Tuple
lst3 :: (a,b,c) -> c
lst3 (_,_,c) = c

black, white :: Solution -> Guess -> Int

black [] [] = 0
black solution guess = if (take 1 solution) == (take 1 guess) then 1 + nextGuess else nextGuess
                       where nextGuess = black (drop 1 solution) (drop 1 guess)
                       
-- This function is called to filter input for the 'white' function, as numbers on the same
-- position are not eligible for selection in the 'white' function.
removeNumbersOnSamePosition :: Row -> Row -> Row
removeNumbersOnSamePosition [] [] = []
removeNumbersOnSamePosition (x:xs) [] = []
removeNumbersOnSamePosition (x:xs) (y:ys) = if x == y
                                            then removeNumbersOnSamePosition xs ys
											else x : removeNumbersOnSamePosition xs ys
                                            
-- Removes a number from a Row. This is used in the 'white' function to prevent inputs such as
-- [1,4,4,1] [4,1,4,4] returning erroneous values: Every time a number from the guess is found
-- in the solution, the number is removed in the solution to prevent the number giving back positive
-- values multiple times.
removeNumber :: Int -> Row -> Row
removeNumber number [] = []
removeNumber number (x:xs) = if number == x then xs else x : removeNumber number xs 

white solution guess = 
 let solveWhite shortSolution shortGuess | shortGuess == [] = 0
                                         | elem (head shortGuess) shortSolution = 1 + nextGuess
                                         | otherwise = nextGuess
										 where nextGuess = solveWhite (removeNumber (head shortGuess) shortSolution ) (drop 1 shortGuess)
 in solveWhite (removeNumbersOnSamePosition solution guess) (removeNumbersOnSamePosition guess solution)
					   
check :: Solution -> Guess -> (Int,   -- number of black points,
                               Int,   -- number of white points
                               Bool)  -- all-correct guess?
check solution guess = let
                        checkBlack = black solution guess
                        checkWhite = white solution guess
                        allCorrect = if checkBlack == 4 && checkWhite == 0 then True
                                                                           else False
                       in (checkBlack, checkWhite, allCorrect)

-- report is supposed to take the result of calling check, and
-- produces a descriptive string to report to the player.
report :: (Int, Int, Bool) -> IO() -- Changed this to IO() for easier integration
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
    processInput l
  where
  processInput :: String -> IO Guess
  processInput "just show me the damn solution" = return [-50]
  processInput "quit" = return [-60]
  processInput l = do
                    let filteredNumbers = map readInt (words l)
                    if valid filteredNumbers == True then return filteredNumbers
                       else do
                         putStrLn ("Incorrect input! Please enter " ++ show width ++ " numbers between 1 and " ++ show colors ++ ", separated by a comma.")
                         input

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
valid guess = if length ( filter (\n -> n >= 1 && n <= colors ) guess ) == width then True else False