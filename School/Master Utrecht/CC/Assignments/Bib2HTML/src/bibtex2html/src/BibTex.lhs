> {-# LANGUAGE FlexibleContexts, UndecidableInstances, TypeSynonymInstances #-}
> -- |This module contains the datatype declarations. There are two prominent datatypes: 'StrBibTex' and 'BibTex'. 'StrBibTex' is used during parsing, and is more liberal in the values of the entry and atrribute types. 'BibTex' only allows certain values for entry and attribute types using the 'EntryType' and 'AttrType' datatypes. Using 'fromTree' and 'toTree', we convert between these two datatypes.
> module BibTex where

> import CCO.Tree
> import CCO.Tree.Parser
> import Control.Applicative
> import Data.Char 

> -- * The BibTex datatype, used in checking and HTML generation

> -- |A complete BibTex file.
> data BibTex = BibTex [Entry]
>  deriving (Show,Read)

> -- |An Entry. Consists of the type of the Entry, the title of the Entry, and a list of attributes.
> data Entry = Entry EntryType EntryTitle [Attr]
>  deriving (Show,Read)

> -- |The type of an Entry.
> data EntryType = Article | Book | Booklet | Conference | Inbook | Incollection | Inproceedings | Manual | Mastersthesis | Misc | Phdthesis | Proceedings | Techreport | Unpublished | OtherEntry String 
>  deriving (Show, Eq, Ord,Read)
> type EntryTitle = String

> -- |An attribute of an Entry. Consists of the type of the attribute, and the attribute value.
> data Attr = Attr AttrType AttrValue
>  deriving (Show, Read)

> -- |The type of an Attribute.
> data AttrType = Author | Editor | Title | Booktitle | Howpublished | Type | Year | Journal | Month | Note | Key | Pages | Chapter | Volume | Number | Edition | Series | Organization | Publisher | School | Institution | Address | OtherAttr String
>  deriving (Show, Read, Eq, Ord)
> type AttrValue = String

> -- |A function that maps over the list of 'AttrType's and produces an appropriate parser for each.
> generateToTreeAttrType :: [AttrType] -> [TreeParser AttrType]
> generateToTreeAttrType = map (\x -> app (show x) (pure x))
> attrTypes = [Author , Editor , Title , Booktitle , Howpublished , Type , Year , Journal , Month , Note , Key , Pages , Chapter , Volume , Number , Edition , Series , Organization , Publisher , School , Institution , Address]

> -- |A function that maps over the list of 'EntryType's and produces an appropriate parser for each.
> generateToTreeEntryType :: [EntryType] -> [TreeParser EntryType]
> generateToTreeEntryType = map (\x -> app (show x) (pure x))
> entryTypes = [Article , Book , Booklet , Conference , Inbook , Incollection , Inproceedings , Manual , Mastersthesis , Misc , Phdthesis , Proceedings , Techreport , Unpublished]

> instance (Show AttrType) => Tree AttrType where
>    fromTree x = App (show x) []
>    toTree = parseTree $ generateToTreeAttrType attrTypes
    
> instance (Tree AttrType, Tree AttrValue) => Tree Attr where
>    fromTree (Attr atype val) = App "Attr" [fromTree atype, fromTree val]
>    toTree = parseTree [app "Attr" (Attr <$> arg <*> arg)]
    
> instance (Show EntryType) => Tree EntryType where
>     fromTree x = App (show x) []
>     toTree = parseTree $ generateToTreeEntryType entryTypes
    
> instance (Tree EntryType, Tree EntryTitle, Tree Attr) => Tree Entry where
>     fromTree (Entry etype title attrs) = App "Entry" [fromTree etype, fromTree title, List $ map fromTree attrs]
>     toTree = parseTree [app "Entry" (Entry <$> arg <*> arg <*> arg)]
    
> instance (Tree Entry) => Tree BibTex where
>     fromTree (BibTex entries) = App "BibTex" [List $ map fromTree entries]
>     toTree = parseTree [app "BibTex" (BibTex <$> arg)]

> -- * The StrBibTex datatype, used in parsing

> data StrBibTex = StrBibTex [StrEntry] deriving Show
> data StrEntry = StrEntry StrEntryType StrEntryTitle [StrAttr] deriving Show
> data StrEntryType = StrEntryType String deriving (Show,Read)
> type StrEntryTitle = String
> data StrAttr = StrAttr StrAttrType StrAttrValue deriving (Show, Read)
> data StrAttrType = StrAttrType String deriving (Show,Read)
> type StrAttrValue = String

> instance Tree StrAttrType where
>    fromTree (StrAttrType x) = App (uflr x) []
>    toTree = undefined

> instance (Tree StrAttrType, Tree StrAttrValue) => Tree StrAttr where
>    fromTree (StrAttr atype val) = App "Attr" [fromTree atype, fromTree val]
>    toTree = undefined

> instance Tree StrEntryType where
>    fromTree (StrEntryType x) = App (uflr x) []
>    toTree = undefined

> instance (Tree StrEntryType, Tree StrEntryTitle, Tree StrAttr) => Tree StrEntry where
>    fromTree (StrEntry etype title attrs) = App "Entry" [fromTree etype, fromTree title, List $ map fromTree attrs]
>    toTree = undefined
    
> instance (Tree StrEntry) => Tree StrBibTex where
>    fromTree (StrBibTex entries) = App "BibTex" [List $ map fromTree entries]
>    toTree = undefined

> {-|
> Converts the head of the string to uppercase, and the tail to lowercase. This function is used when converting a 'String' into an 'EntryType' or 'AttrType'.
> 
> Examples:
> 
> \"hello\" = \"Hello\"
> 
> \"HElLo\" = \"Hello\"
> 
> -}
> uflr :: String -> String
> uflr (x:xs) = (toUpper x : (map toLower xs))
> uflr [] = []

