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
    runTCPServer (serverSettings defaultPort "*") (runnr 0)

runnr n appData =
    appSource appData $$  conduit n =$ appSink appData

logYield s = do
    liftIO $ do
        BC.putStr "Probably sending\t"
        BC.putStrLn s
    yield s

conduit :: Int -> ConduitM BC.ByteString BC.ByteString IO ()
conduit n = do
    str <- await
    case str of
         Nothing -> return ()
         (Just s) -> do
             logYield $ BC.concat [
                 "[\"ex\",",
                "\"echo '",
                BC.pack . show $ n,
                "\t",
                BC.reverse "HI",
                "'\"]\n"
                 ]
             conduit (succ n)

sink :: IORef Int -> Sink String IO ()
sink state = do
    str <- await
    case str of
         Nothing -> return ()
         (Just s) -> do
            liftIO $ putStrLn s
            liftIO $ modifyIORef' state succ
            sink state

