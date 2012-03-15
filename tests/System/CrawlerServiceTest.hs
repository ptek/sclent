{-# LANGUAGE OverloadedStrings #-}
module System.CrawlerServiceTest (tests) where

import Control.Applicative ((<$>))
import Da.Http (fetchLinks)
import Data.Text (Text(..))
import Service.CrawlerService
import Test.HUnit
import Text.HTML.TagSoup

tests = test [
  "crawl the pages downloaded by DA module and find backlinks" ~: test [
    then_ (runCrawler fetchLinks "http://github.com" ["http://kerestey.net"]) (@?= [("http://kerestey.net",True)])
  ]
  ]

then_ action assertion = assertion <$> action