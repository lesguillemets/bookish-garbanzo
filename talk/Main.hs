{-# LANGUAGE OverloadedStrings #-}
module Main where
-- https://www.schoolofhaskell.com/user/joehillen/building-an-async-chat-server-with-conduit
import Lib
import Data.Conduit
import Data.Conduit.Network
import Data.Conduit.Text
import qualified Data.ByteString.Char8 as BC
import Control.Monad.IO.Class
import Control.Lens
import Data.Aeson.Lens
import qualified Data.Text as T
import Data.Text (Text)
import qualified Data.Text.IO as TI
import Data.Text.Encoding (decodeUtf8, encodeUtf8)

jsonString :: BC.ByteString
jsonString = "[ 1, \"Hello world\"]"

main :: IO ()
main = do
    runTCPServer (serverSettings defaultPort "*") runnr

runnr appData =
    appSource appData $$ decode utf8
                      =$ conduit
                      =$ encode utf8
                      =$ appSink appData

logYield s = do
    liftIO $ do
        TI.putStr "Probably sending\t"
        TI.putStrLn s
    yield s

conduit :: ConduitM Text Text IO ()
conduit = do
    str <- await
    case str of
         Nothing -> return ()
         (Just s) -> do
             logYield . processmsg $ s
             conduit

processmsg :: Text -> Text
processmsg msg =
    T.concat [
        "[",
        T.pack . show $ n,
        ",\"",
        T.reverse txt,
        "\"]"
    ]
    where
        Just n = msg ^? nth 0 . _Integral
        Just txt = msg ^? nth 1 . _String
