{-# LANGUAGE OverloadedStrings #-}
module Da.Http (fetchLinks) where

import Control.Applicative ((<$>))
import Control.Monad.IO.Class
import qualified Control.Exception    as E
import qualified Data.ByteString      as B
import qualified Data.ByteString.Lazy as BL
import Data.Text (Text, unpack)
import Data.Text.Encoding
import Network.HTTP.Enumerator
import Network.HTTP.Types (ResponseHeaders)
import System.IO
import Text.HTML.TagSoup

fetchLinks :: Text -> IO [Tag Text]
fetchLinks url = (filterLinksOnly . parseTags) <$> E.catch (downloadPage url) (anyIoError url)

anyIoError :: Text -> E.IOException -> IO Text
anyIoError url e = do
  hPutStrLn stderr ("Warning: Couldn't fetch " ++(show url)++ ": " ++ (show e))
  return ""

downloadPage :: MonadIO m => Text -> m Text
downloadPage url = do
  url' <- liftIO $ parseUrl (unpack url)
  r <- liftIO $ withManager $ httpLbsRedirect $ url' { decompress = browserDecompress }
  return (body r)

body :: Response -> Text
body (Response sc h b) =
  if (contentIsHtml h) && 200 <= sc && sc < 300
    then decodeUtf8 $ toStrict b
    else ""

toStrict :: BL.ByteString -> B.ByteString
toStrict = B.concat . BL.toChunks

contentIsHtml :: ResponseHeaders -> Bool
contentIsHtml hs = snd ((filter contentType hs) !! 0) == "text/html" where
  contentType = ((==) "Content-Type") . fst

filterLinksOnly :: [Tag Text] -> [Tag Text]
filterLinksOnly tags = filter isLink tags
  where
    isLink (TagOpen "a" _) = True
    isLink _               = False