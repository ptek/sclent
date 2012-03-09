module Model.Crawler where

import Data.Text
import Text.HTML.TagSoup

findBackLink :: String -> [Tag Text] -> Bool
findBackLink _ _ = True