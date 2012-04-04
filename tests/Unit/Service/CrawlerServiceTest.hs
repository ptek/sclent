{-# LANGUAGE OverloadedStrings #-}
module Unit.Service.CrawlerServiceTest (tests) where

import Control.Applicative ((<$>))
import Data.Text
import Service.CrawlerService
import Test.HUnit
import Text.HTML.TagSoup (Tag(..))

tests = [
  "runs crawler" ~: test [
     testIO (runCrawler fetcherMock1 "git.io" ["http://k.net"]) (@?= [("http://k.net",True)])
    ,testIO (runCrawler fetcherMock2 "git.io" ["http://k.net"]) (@?= [("http://k.net",True)])
    ,testIO (runCrawler fetcherMock3 "git.io" ["http://k.net"]) (@?= [("http://k.net",True)])
    ,testIO (runCrawler fetcherMock4 "git.io" ["http://k.net"]) (@?= [("http://k.net",False)])
    ]
  ]

fetcherMock1 "http://k.net"   = return [TagOpen "a" [("href", "git.io")]]

fetcherMock2 "http://k.net"   = return [TagOpen "a" [("href", "/a")]]
fetcherMock2 "http://k.net/a" = return [TagOpen "a" [("href", "git.io")]]

fetcherMock3 "http://k.net"   = return [TagOpen "a" [("href", "/a")]]
fetcherMock3 "http://k.net/a" = return [TagOpen "a" [("href", "/b")]]
fetcherMock3 "http://k.net/b" = return [TagOpen "a" [("href", "git.io")]]

fetcherMock4 "http://k.net"   = return [TagOpen "a" [("href", "/a")]]
fetcherMock4 "http://k.net/a" = return [TagOpen "a" [("href", "/b")]]
fetcherMock4 "http://k.net/b" = return [TagOpen "a" [("href", "/c")]]
fetcherMock4 "http://k.net/c" = return [TagOpen "a" [("href", "git.io")]]

testIO action assertion = assertion <$> action