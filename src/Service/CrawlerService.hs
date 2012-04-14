{-# LANGUAGE OverloadedStrings #-}
module Service.CrawlerService (
  runCrawler
) where

import Control.Monad.IO.Class
import Data.Enumerator (Iteratee(..), ($$), run_, enumList)
import qualified Data.Enumerator.List as EL
import Data.List ((\\),nub)
import Data.Text (Text)
import Text.HTML.TagSoup (Tag(..))
import Model.Crawler

runCrawler :: (Text -> IO [Tag Text]) -> Text -> [Text] -> IO [(Text, Bool)]
runCrawler fetcher dFor dOn = run_ (enumList 1 dOn $$ search) where
  search :: Iteratee Text IO [(Text, Bool)]
  search = do
    maybeDomain <- EL.head
    case maybeDomain of
      Nothing -> return []
      Just d -> do
        rest <- search
        found <- liftIO (crawl fetcher dFor d [d] [] 3)
        return ([(d,found)] ++ rest)

crawl :: (Text -> IO [Tag Text]) -> Text -> Text -> [Text] -> [Text] -> Int -> IO Bool
crawl _       _      _      _       _   0     = return False
crawl fetcher target domain sources acc depth = do
  tags <- (mapM fetcher sources >>= return . nub . concat)
  if (findBackLink target tags)
    then return True
    else do
    let newLinks = (nub (findLocalLinks domain tags)) \\ acc
    crawl fetcher target domain newLinks (acc ++ newLinks) (depth-1)
