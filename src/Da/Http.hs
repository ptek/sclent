{-# LANGUAGE OverloadedStrings #-}
module Da.Http (fetchLinks) where

import Control.Applicative ((<$>))
import Control.Exception.Base
import Data.List (filter)
import Data.Text (Text(..), pack, unpack)
import Data.Text.Encoding
import Network.HTTP
import Network.HTTP.Base (Request(..), Response(..), mkRequest, catchIO)
import Network.HTTP.Headers (Header(..))
import Network.Stream (Result)
import Network.URI (parseURI)
import Text.HTML.TagSoup

fetchLinks :: Text -> IO [Tag Text]
fetchLinks url = (filterLinksOnly . parseTags) <$> fetchPage url

fetchPage :: Text -> IO Text
fetchPage url = case parseURI (unpack url) of
  Nothing -> return ""
  Just u -> catchIO (simpleHTTP (mkRequest GET u) >>= fetchBody) report

report :: IOException -> IO Text
report e = putStrLn ("Could not get "++(show e)) >> return ""

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