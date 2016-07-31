module Main where
import Control.Monad          (msum)
import Control.Monad.Trans    (MonadIO)
import qualified Data.Text    as T
import Happstack.Server       (dir, nullConf, nullDir, simpleHTTP)
import Happstack.Server.Heist (templateServe, templateReloader)
import Text.Templating.Heist  (TemplateMonad, Template, TemplateState
                              , bindSplice, emptyTemplateState, getParamNode)
import Text.Templating.Heist.TemplateDirectory (newTemplateDirectory')
import qualified Text.XmlHtml as X
factSplice :: (Monad m) => TemplateMonad m Template
factSplice = do
  input <- getParamNode
  let text = T.unpack $ X.nodeText input
      n    = read text :: Int
  return [X.TextNode $ T.pack $ show $ product [1..n]]

templateState :: (MonadIO m) => 
                 FilePath -- ^ path to template directory
              -> TemplateState m
templateState templateDir = bindSplice (T.pack "fact") factSplice emptyTemplateState

main :: IO ()
main = do
    let templateDir = "."
    td <- newTemplateDirectory' templateDir (templateState templateDir)
    simpleHTTP nullConf $ msum 
       [ templateServe td
       , dir "reload" $ nullDir >> templateReloader td
       ]
