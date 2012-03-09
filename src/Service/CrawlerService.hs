{-# LANGUAGE OverloadedStrings #-}
module Service.CrawlerService (
  crawl
) where

import Data.Text
import Text.HTML.TagSoup
import Model.Crawler

crawl :: Text -> IO ([Text],[Text])
crawl _ = return (["I am"],["Sclent"])

foo = findBackLink "http://hoogle.de" [(TagOpen "a" [])]