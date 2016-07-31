> {-# LANGUAGE OverloadedStrings #-}
> module Main where
>
> import Happstack.Server
> import Control.Monad

> import           Text.Blaze ((!))
> import qualified Text.Blaze.Html4.Strict as H
> import qualified Text.Blaze.Html4.Strict.Attributes as A
>
> appTemplate :: String -> [H.Html] -> H.Html -> H.Html
> appTemplate title headers body =
>     H.html $ do
>       H.head $ do
>         H.title (H.string title)
>         H.meta ! A.httpEquiv "Content-Type" ! A.content "text/html;charset=utf-8"
>         sequence_ headers
>       H.body $ do
>         body
>
> helloBlaze :: ServerPart Response
> helloBlaze = 
>    ok $ toResponse $ 
>     appTemplate "Hello, Blaze!" 
>                 [H.meta ! A.name "keywords" ! A.content "happstack, blaze, html"] 
>                 (H.p "hello, blaze!")

> numberblaze :: ServerPart Response
> numberblaze = ok $ toResponse $ numbers 5

> base :: ServerPart Response
> base = ok $ toResponse $ H.p "Hello, world!"


> numbers :: Int -> H.Html
> numbers n = H.docTypeHtml $ do
>     H.head $ do
>         H.title "Natural numbers"
>     H.body $ do
>         H.p "A list of natural numbers:"
>         H.ul $ forM_ [1 .. n] (H.li . H.toHtml)

>
> main :: IO ()
> main = simpleHTTP nullConf $ msum [ base,
>                                     dir "hello"    $ helloBlaze
>                                   , dir "goodbye"  $ numberblaze
>                                   ]