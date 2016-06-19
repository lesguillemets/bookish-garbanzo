{-# LANGUAGE OverloadedStrings #-}
module Main where
-- https://www.schoolofhaskell.com/user/joehillen/building-an-async-chat-server-with-conduit
import Lib
import Data.Conduit
import Data.Conduit.Network
import qualified Data.ByteString.Char8 as BC
import Control.Monad.IO.Class
import Control.Lens
import Data.Aeson.Lens

jsonString :: BC.ByteString
jsonString = "[ 1, \"Hello world\"]"

main = do
    print $ jsonString ^? nth 1 . _String
    (print :: Maybe Int -> IO ()) $ jsonString ^? nth 0 . _Integral

main' :: IO ()
main' = do
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
                 "[",
                "\"ex\"" ,
                ",",
                "\"echo '",
                BC.pack . show $ n,
                "\t",
                BC.reverse "HI",
                "'\"]\n"
                 ]
             conduit (succ n)
