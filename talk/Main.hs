{-# LANGUAGE OverloadedStrings #-}
module Main where
-- https://www.schoolofhaskell.com/user/joehillen/building-an-async-chat-server-with-conduit
import Lib
import Data.Conduit
import Data.Conduit.Network
import qualified Data.ByteString.Char8 as BC
import Control.Monad.IO.Class
import Data.IORef
import System.IO

main :: IO ()
main = do
    n <- newIORef 0
    runTCPServer (serverSettings defaultPort "*") (runnr n)

runnr n appData = do
    appSource appData $$  conduit =$ sink n

conduit :: ConduitM BC.ByteString String IO ()
conduit = do
    str <- await
    case str of
         Nothing -> return ()
         (Just s) -> do
             yield . BC.unpack $ s
             conduit

sink :: IORef Int -> Sink String IO ()
sink state = do
    str <- await
    case str of
         Nothing -> return ()
         (Just s) -> do
            liftIO $ putStrLn s
            liftIO $ modifyIORef' state succ
            sink state

