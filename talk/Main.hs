{-# LANGUAGE OverloadedStrings #-}
module Main where
-- https://www.schoolofhaskell.com/user/joehillen/building-an-async-chat-server-with-conduit
import Lib
import Data.Conduit
import Data.Conduit.Network
import Data.ByteString (ByteString)
import Control.Monad.IO.Class (liftIO)
import System.Exit (exitSuccess)
import Control.Concurrent.MVar
import Control.Exception

main :: IO ()
main = do
    exitter <- newEmptyMVar
    forkTCPServer (serverSettings defaultPort "*") $ \ appData ->
        appSource appData $$ conduit exitter =$= appSink appData
    takeMVar exitter *> putStrLn "exit."

conduit :: MVar () -> ConduitM ByteString ByteString IO ()
conduit m = do
    str <- await
    case str of
         Nothing -> liftIO $ do
             putStrLn "Nothing left"
             putMVar m ()
         (Just s) -> do
             yield s
             conduit m
