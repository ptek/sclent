{-# LANGUAGE OverloadedStrings #-}
module Unit.Model.CrawlerTest (tests) where

import Data.Text
import Model.Crawler
import Test.HUnit
import Text.HTML.TagSoup

tests = test [
  "finds the link among the tags" ~: test [
     findBackLink "http://foo.bar" [(TagOpen "a" [])] ~?= False
    ,findBackLink "http://foo.bar" [(TagOpen "a" [("href","http://foo.bar")])] ~?= True
    ,findBackLink "http://foo.bar" [(TagOpen "a" [("href","http://bar.baz")])] ~?= False
    ,findBackLink "http://foo.bar" [(TagOpen "div" [])] ~?= False
    ,findBackLink "http://foo.bar" [(TagOpen "script" [("href","http://foo.bar")])] ~?= False
    ]
 ,"finds the links to the current domain ignoring the other ones" ~: test [
     findLocalLinks "http://a.net" [] ~?= []
    ,findLocalLinks "http://a.net" [(TagOpen "a" [("href", "http://foo.bar")])] ~?= []
    ,findLocalLinks "http://a.net" [(TagOpen "div" [])] ~?= []
    ,findLocalLinks "http://a.net" [(TagOpen "script" [("href", "http://a.net")])] ~?= []
    ,findLocalLinks "http://a.net" [(TagOpen "script" [("href", "/")])] ~?= []
    ,findLocalLinks "http://a.n" [(TagOpen "a" [("href", "/")])] ~?= ["http://a.n/"]
    ,findLocalLinks "http://a.n" [(TagOpen "a" [("href", "/index.html")])] ~?= ["http://a.n/index.html"]
    ,findLocalLinks "http://a.n" [(TagOpen "a" [("href", "http://a.n")])] ~?= ["http://a.n"]
    ,findLocalLinks "http://a.n" [(TagOpen "a" [("href", "http://a.n/foo.html")])] ~?= ["http://a.n/foo.html"]
    ]
 ]