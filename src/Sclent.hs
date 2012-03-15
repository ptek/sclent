{-# LANGUAGE OverloadedStrings #-}
module Main where

import Da.Http (fetchLinks)
import Data.Text (Text(..), pack)
import Service.CrawlerService
import System.Environment
import System.Exit

args :: IO [Text]
args = do
  a <- getArgs >>= return . (map pack)
  if (length a) < 2
    then putStrLn "usage: sclent <target> <source1> <source2> ..." >> exitFailure
    else return a

main :: IO ()
main = do
  (target:sources) <- args
  runCrawler fetchLinks target sources >>= printToStdout

printToStdout :: [(Text,Bool)] -> IO ()
printToStdout results = putStrLn "=== Found:"     >> printSuccesses
                     >> putStrLn "=== Not Found:" >> printFailures
  where
    printFailures = printResults (filter (not . snd) results)
    printSuccesses = printResults (filter (snd) results)
    printResults :: [(Text, Bool)] -> IO ()
    printResults r = (mapM (putStrLn) . map (show . fst)) r >> return ()
