module Chat.Chat where

import Network
import System.IO
import Control.Concurrent
import Control.Exception
import Data.List(delete)

-- ** Port

serverport = PortNumber 4242

-- ** Client

startClient :: String -> String -> IO ()
startClient host nick = withSocketsDo $ 
 do
    handle <- connectTo host serverport                 -- Connect to server
    listenToServer handle                               -- Listen to server messages
    msg handle nick                                     -- Inform server of login
    input <- getContents                                -- Receive user input
    sequence_ $ map (msg handle) $ lines input          -- Send input to the server
    hClose handle                                       -- Close server connection
 where
    msg h text = sendMessage h text
     
sendMessage :: Handle -> String -> IO ()
sendMessage handle text = 
 do 
    hPutStrLn handle $ text                             -- Send text to the server
    hFlush handle                                       -- Flush buffer
                               
listenToServer :: Handle -> IO ThreadId
listenToServer handle = forkIO $ sequence_ $ repeat $ handleMessage handle  -- Receive server messages           
                            
handleMessage :: Handle -> IO ()
handleMessage handle = 
 do 
    message <- hGetLine handle                          -- Read a single line from server
    putStrLn message                                    -- Put it on client terminal

-- ** Server

type UserData = [(Handle,String)]

startServer :: IO ()
startServer = withSocketsDo $
 do
    socket <- listenOn serverport                       -- Listen for client connections
    users <- newMVar ([]::UserData)                     -- Initialize user list
    sequence_ $ repeat $ (acceptClientConnection socket users) -- Accept user connections
    
acceptClientConnection :: Socket -> MVar UserData -> IO ThreadId
acceptClientConnection s u  = 
 do 
    conn <- accept s                                    -- Accept a connection
    let (handle, host, portnum) = conn                  -- Get some more info about it
    username <- hGetLine handle                         -- Client will have sent his username over, save it
    updateUsers u handle username                       -- Update user list
    sendMessageToAll (username ++ " connected.") u      -- Inform everyone that someone joined
    forkIO (handleUser handle u username)               -- Fork to handle user's messages
                          
handleUser :: Handle -> MVar UserData -> String -> IO ()
handleUser h u nick = 
 handle (\(SomeException _) -> handleUserQuit h u nick) $ 
 do
     message <- hGetLine h                               -- Get message from the user
     sendMessageToAll (nick ++ ": " ++ message) u        -- Send the message to everyone
     handleUser h u nick

handleUserQuit :: Handle -> MVar UserData -> String -> IO ()
handleUserQuit h u nick =
 do
     deleteUser u h nick
     sendMessageToAll (nick ++ " left.") u
     hClose h

deleteUser :: MVar UserData -> Handle -> String -> IO ()
deleteUser all old name = 
 do
    users <- takeMVar all
    putMVar all (delete (old,name) users)
                                                 
sendMessageToAll :: String -> MVar UserData -> IO ()
sendMessageToAll message users = 
 do 
    u <- readMVar users                                 -- Read user list
    sequence_ $ map (\(h,n) -> sendMessageDebug h n message) u -- Send message to every user

sendMessageDebug :: Handle -> String -> String -> IO ()
sendMessageDebug handle nick text = 
 do 
    putStr $ "Sending message to " ++ nick ++ "\n"      -- Debug info
    sendMessage handle text                             -- Send message
                                          
updateUsers :: MVar UserData -> Handle -> String -> IO ()
updateUsers all new name = 
 do 
    users <- takeMVar all                               -- Get user list
    putMVar all ((new,name):users)                      -- Update user list
