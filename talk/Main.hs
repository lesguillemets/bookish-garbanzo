{-# LANGUAGE OverloadedStrings #-}
module Main where
-- https://www.schoolofhaskell.com/user/joehillen/building-an-async-chat-server-with-conduit
import Lib
import Data.Conduit
import Data.Conduit.Network
import qualified Data.ByteString.Char8 as BC
import Control.Monad.IO.Class
import System.IO

main :: IO ()
main = runTCPServer (serverSettings defaultPort "*") runnr

runnr appData = do
    appSource appData $$  conduit =$ sink 0

conduit :: ConduitM BC.ByteString String IO ()
conduit = do
    str <- await
    case str of
         Nothing -> return ()
         (Just s) -> do
             yield . BC.unpack $ s
             conduit

sink :: Int -> Sink String IO ()
sink state = do
    str <- await
    case str of
         Nothing -> return ()
         (Just s) -> do
            liftIO $ putStrLn s
            sink . succ $ state

