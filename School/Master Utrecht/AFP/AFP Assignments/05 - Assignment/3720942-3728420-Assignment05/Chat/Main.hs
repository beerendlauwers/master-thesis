module Main where

import System.Console.GetOpt
import System.Environment
import Chat.Chat
import Chat.Flags

options :: [OptDescr Flag]
options = [ Option ['s'] [] (NoArg Server) "run as server" ]

mainOpts :: [String] -> IO Flag
mainOpts argv =
  case getOpt RequireOrder options argv of
    (o,[],[]) | not . null $ o -> return (maximum o)
    ([],(h:n:xs),[] ) -> return (Client h n)
    (_,_,errs) -> ioError (userError (concat errs ++ usageInfo header options))
  where
    header = "Usage: chat -s | <hostname> <nickname>"

-- | Main program.
-- Should parse for server flag (-s) or hostname and nickname if it is to be used as a client.
main :: IO ()
main = do argv <- getArgs
          opt <- mainOpts argv
          start opt

start :: Flag -> IO()
start (Client h n) = startClient h n
start Server = startServer