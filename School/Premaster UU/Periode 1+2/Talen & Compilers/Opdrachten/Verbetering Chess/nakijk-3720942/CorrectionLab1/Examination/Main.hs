module Main (main) where

-- import Examination.UU.AST
import Examination.UU.Review.Parser
import System.Environment

fullparse :: String -> Bool
fullparse = any (null.snd) . parseFile
               
main :: IO ()
main = do
    (p : _) <- getArgs
    f <- readFile p
    case fullparse f of
        True -> putStrLn "Valid examination form!"
        False -> putStrLn "Invalid examination form!"
