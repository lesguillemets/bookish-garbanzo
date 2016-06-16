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
main = runTCPServer (serverSettings defaultPort "*") $ \appData ->
    appSource appData $$ awaitForever $ liftIO . BC.putStr
