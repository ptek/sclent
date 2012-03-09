{-# LANGUAGE OverloadedStrings #-}
module Unit.Model.CrawlerTest (tests) where

import Data.Text
import Model.Crawler
import Test.HUnit
import Text.HTML.TagSoup

tests = test [
  "finds the link among the tags" ~: test [
     findBackLink "http://foo.bar" [(TagOpen "a" [("href","http://foo.bar")])] ~?= True
     ]
  ]