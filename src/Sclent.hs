{-# LANGUAGE OverloadedStrings #-}
module Main where

import Service.CrawlerService

main :: IO ()
main = crawl "http://foo.bar" >>= putStrLn . show
