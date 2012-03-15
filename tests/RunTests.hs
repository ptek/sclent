module Main where

import Test.HUnit
import qualified System.CrawlerServiceTest (tests)
import qualified Unit.Model.CrawlerTest (tests)
import qualified Unit.Service.CrawlerServiceTest (tests)

main :: IO ()
main = runTestTT unitTests
    >> runTestTT systemTests
    >> return ()

unitTests = test [
  "CrawlerTest" ~: Unit.Model.CrawlerTest.tests
 ,"CrawlerServiceTest" ~: Unit.Service.CrawlerServiceTest.tests
 ]

systemTests = test [
  "CrawlerServiceTest" ~: System.CrawlerServiceTest.tests
  ]