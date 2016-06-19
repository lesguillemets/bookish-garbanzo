{-# LANGUAGE OverloadedStrings #-}
module Main where
-- https://www.schoolofhaskell.com/user/joehillen/building-an-async-chat-server-with-conduit
import Lib
import Data.Conduit
import Data.Conduit.Network
import Data.ByteString (ByteString)
import Control.Monad.IO.Class (liftIO)
import System.Exit (exitSuccess)

main :: IO ()
main = runTCPServer (serverSettings defaultPort "*") $ \ appData ->
        appSource appData $$ conduit =$= appSink appData

conduit :: ConduitM ByteString ByteString IO ()
conduit = do
    str <- await
    case str of
         Nothing -> liftIO $ do
             putStrLn "Nothing left"
             exitSuccess
         (Just s) -> case s of
                          "quit\n" -> liftIO $ putStrLn "Quit?" *> exitSuccess
                          _ -> do
                              yield s
                              conduit
