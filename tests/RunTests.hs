module Main where

import Test.HUnit
import qualified Unit.Model.CrawlerTest (tests)

main :: IO ()
main = runTestTT unitTests >> return ()

unitTests = test [
  "CrawlerTest" ~: Unit.Model.CrawlerTest.tests
  ]