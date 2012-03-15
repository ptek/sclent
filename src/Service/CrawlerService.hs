module Service.CrawlerService (
  runCrawler
) where

import Control.Applicative ((<$>))
import Data.List ((\\),nub)
import Data.Text (Text(..))
import Text.HTML.TagSoup (Tag(..))
import Model.Crawler

runCrawler :: (Text -> IO [Tag Text]) -> Text -> [Text] -> IO [(Text, Bool)]
runCrawler fetcher domainToSearchFor domainsToSearchOn = mapM search domainsToSearchOn where
  search d = do
    found <- crawl fetcher domainToSearchFor d [d] [] 3
    return (d, found)

crawl :: (Text -> IO [Tag Text]) -> Text -> Text -> [Text] -> [Text] -> Int -> IO Bool
crawl _       _      _      _       _   0     = return False
crawl fetcher target domain sources acc depth = do
  tags <- (mapM fetcher sources >>= return . nub . concat)
  if (findBackLink target tags)
    then return True
    else do
    let newLinks = nub ((\\) (nub (findLocalLinks domain tags)) acc)
    crawl fetcher target domain newLinks (acc ++ newLinks) (depth-1)
