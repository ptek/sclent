{-# LANGUAGE OverloadedStrings #-}
module Da.Http (fetchLinks) where

import Control.Applicative ((<$>))
import Data.List (filter)
import Data.Text (Text(..), pack, unpack)
import Data.Text.Encoding
import Network.Curl.Download (openURIString)
import Text.HTML.TagSoup

fetchLinks :: Text -> IO [Tag Text]
fetchLinks url = (filterLinksOnly . parseTags) <$> openAsTags url

filterLinksOnly :: [Tag Text] -> [Tag Text]
filterLinksOnly tags = filter isLink tags
  where
    isLink (TagOpen "a" _) = True
    isLink _               = False

openAsTags :: Text -> IO Text
openAsTags s = handleDownload <$> openURIString (unpack s)
  where
    handleDownload :: (Either String String) -> Text
    handleDownload (Left _) = ""
    handleDownload (Right content) = (pack content)