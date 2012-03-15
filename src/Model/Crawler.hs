{-# LANGUAGE OverloadedStrings #-}
module Model.Crawler (
  findBackLink
 ,findLocalLinks
 ) where

import Data.Text (Text(..),concat,length,take)
import Text.HTML.TagSoup
import Prelude hiding (concat,length,take)

findBackLink :: Text -> [Tag Text] -> Bool
findBackLink target tags = any (testLink target) tags

findLocalLinks :: Text -> [Tag Text] -> [Text]
findLocalLinks domain tags = findRelativeTags ++ findAbsoluteTags
  where
    findRelativeTags = map (prependDomain . extractHref) (filter (testLink "/") tags)
    findAbsoluteTags = map extractHref (filter (testLink domain) tags)

    prependDomain :: Text -> Text
    prependDomain l = concat [domain, l]

    extractHref :: Tag Text -> Text
    extractHref (TagOpen _ attrs) = (map snd (filter (\(a,_) -> a == "href") attrs)) !! 0
    extractHref _                 = ""

testLink :: Text -> Tag Text -> Bool
testLink target (TagOpen "a" attrs) = any (testHrefBeginning target) attrs
testLink target _                   = False

testHrefBeginning :: Text -> (Text, Text) -> Bool
testHrefBeginning target ("href", href) = target == (take (length target) href)
testHrefBeginning _      _              = False
