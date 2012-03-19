{-# LANGUAGE OverloadedStrings #-}
module Da.Http (fetchLinks) where

import Control.Applicative ((<$>))
import Control.Exception.Base
import Data.List (filter)
import Data.Text (Text(..), pack, unpack)
import Data.Text.Encoding
import Network.HTTP
import Network.HTTP.Base (Response(..), catchIO)
import Network.HTTP.Headers (Header(..))
import Network.Stream (Result)
import Text.HTML.TagSoup

fetchLinks :: Text -> IO [Tag Text]
fetchLinks url = (filterLinksOnly . parseTags) <$> fetchPage url

fetchPage :: Text -> IO Text
fetchPage url = catchIO (simpleHTTP (getRequest (unpack url)) >>= fetchBody) report

report :: IOException -> IO Text
report _ = return ""

fetchBody :: (Result (Response String)) -> IO Text
fetchBody res = case lookupHeader HdrContentType (headers res) of
  Just "text/html" -> pack <$> getResponseBody res
  otherwise        -> return ""
  where
    headers :: (Result (Response String)) -> [Header]
    headers (Right rsp) = rspHeaders rsp
    headers _           = []

filterLinksOnly :: [Tag Text] -> [Tag Text]
filterLinksOnly tags = filter isLink tags
  where
    isLink (TagOpen "a" _) = True
    isLink _               = False