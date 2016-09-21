-- |This module pretty-prints an HTML 'ATerm'. Its 'main' function uses 'ioWrap' 'pipeline' for pipe-passing mode.
module PPHTML where

import BibTex

import CCO.Tree
import CCO.Component
import Control.Arrow

-- |This calls 'ioWrap' 'pipeline'.
main :: IO ()
main = ioWrap pipeline

-- |Pretty-printer from 'ATerm' to 'String'.
prettyPrintHTML :: Component ATerm String
prettyPrintHTML = component $ \aterm -> do return $ prettyPrint aterm

-- | Parse a 'String' into an 'ATerm' using 'CCO.Tree.parser', and then use 'prettyPrintHTML' on it.
pipeline :: Component String String
pipeline = CCO.Tree.parser >>> prettyPrintHTML

-- | Pretty-printer, starting at 0 indentation. Uses 'prettyPrint''.
prettyPrint :: ATerm -> String
prettyPrint a = prettyPrint' 0 a

-- | Pretty-printer with indentation.
prettyPrint' :: Int -> ATerm -> String
prettyPrint' i (App con []) = putStrLn' (ind i (emptyTag con))
prettyPrint' i (App con atss) = case atss of 
                                  ((String s):[]) -> putStrLn' (ind i (tag con s))                                 
                                  atss' -> (putStrLn' (ind i (openTag con))) ++ (concat (map (prettyPrint' (i+1)) atss')) ++ (putStrLn' (ind i (closeTag con)))
prettyPrint' i (String s) = putStrLn' (ind i s)
prettyPrint' i (Ann aterm atrs) = case aterm of
                                     (App con atss) -> (putStrLn' (ind i ("<"++con++(concat (map formHTMLAttr atss)))++">")) ++ (concat (map (prettyPrint' (i+1)) atrs)) ++ (putStrLn' (ind i (closeTag con)))
                                     _ -> error "Invalid Annotation ATerm"
prettyPrint' i (List xs) = concat (map (prettyPrint' i) xs)
prettyPrint' _ _ = ""

-- | Turns an 'App' 'ATerm' into an HTML attribute.
formHTMLAttr :: ATerm -> String
formHTMLAttr (App con [(String s)]) = " "++con++"=\""++s++"\""
formHTMLAttr _ = error "Invalid HTML Attribute ATerm"

-- | Indent a 'String' with an amount of spaces.
ind :: Int -> String -> String
ind i s = (take (i*2) (repeat ' '))++s

-- | Given a tag and a value, put tags around the value. Example:

-- | @ tag \"head\" \"value\" @ becomes \<head\>value\<\/head\>
tag :: String -> String -> String
tag con str = (openTag con) ++ str ++ (closeTag con)

-- | Adds an opening tag: @ \"head\" @ => \<head\>
openTag :: String -> String
openTag c = "<"++c++">"

-- | Adds an closing tag: @ \"head\" @ => \<\/head\>
closeTag :: String -> String
closeTag c = "</"++c++">"

-- | Creates a singleton tag: @ \"head\" @ => \<head\/\>. Usually used for @br@, @hr@ or @img@ tags.
emptyTag :: String -> String
emptyTag c = "<"++c++"/>"

-- | Adds a newline to the 'String'.
putStrLn':: String -> String
putStrLn' x = (x ++ "\n")
