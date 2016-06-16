module Main where

import Lib
import Network
import System.IO

main :: IO ()
main = withSocketsDo $ do
    hSetBuffering stdin LineBuffering
    hSetBuffering stdout LineBuffering
    sock <- listenOn $ PortNumber defaultPort
    putStrLn "listening on port 4567"
    handleConnection sock

handleConnection :: Socket -> IO ()
handleConnection sock = do
    (handle, host, port) <- accept sock
    hSetBuffering handle LineBuffering
    output <- hGetLine handle
    putStrLn output
    handleConnection sock
