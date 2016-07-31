-- |This module provides basic parsing functionality to parse a BibTex file to a 'StrBibTex' datatype. Does not use 'Component's for pipe-passing mode because of its simplicity.
module ParseBib where

import BibTex
import UU.Parsing
import UU.Parsing.CharParser
import UU.Parsing.Derived
import UU.Scanner.TokenParser

import CCO.Tree

-- |Reads all the contents from standard input, attempts to parse it and convert it to an 'ATerm', and prints out a textual version of the 'ATerm' on standard output.
main :: IO ()
main = do rawBibtex <- getContents
          parsedBibTex <- parseBibTexString rawBibtex
          let aTermBibTex = fromTree parsedBibTex
          putStrLn $ show aTermBibTex

-- |Try to parse a 'String' to an 'StrBibTex' datatype.
parseBibTexString :: String -> IO StrBibTex
parseBibTexString = parseIO pBibTex

-- Datatype combinated parsers

-- *Datatype combinators

-- | Parse a 'String' to a 'BibTex' datatype. The 'String' can be a list of entries with possible whitespace inbetween.
pBibTex :: Parser Char StrBibTex
pBibTex = StrBibTex <$> pList (pWrapWhitespace pEntry)

-- | Parse a single 'BibTex' entry.
pEntry :: Parser Char StrEntry
pEntry = StrEntry <$> (pSym '@' *>  pEntryType)
               <*> ((pSym '{' *> pWhiteSpace *> pEntryTitle) <* pSym ',' <* pWhiteSpace )
               <*> ((pListSep_ng (pWrapWhitespace $ pSym ',') pAttr) <* pWhiteSpace <* pSym '}' <* pWhiteSpace)

-- | Parse the type of an 'Entry' as a 'String'.
pEntryType :: Parser Char StrEntryType
pEntryType = StrEntryType <$> pAnyWord

-- | Parse the title of an 'Entry' as a 'String'.
pEntryTitle :: Parser Char StrEntryTitle
pEntryTitle = pAnyWord

-- | Parses an attribute, consisting of an 'AttrType' and 'AttrValue'.
pAttr :: Parser Char StrAttr
pAttr = StrAttr <$> (pAttrType <* pWrapWhitespace( pSym '=' )) <*> pAttrValue

-- | Parses an 'AttrType'.
pAttrType :: Parser Char StrAttrType
pAttrType = StrAttrType <$> pAnyWord

-- | Parses an 'AttrValue'.
pAttrValue :: Parser Char StrAttrValue
pAttrValue = pMQWordWithSpaces

-- *Helper combinators

-- | Parses a double quote.
pQuote :: Parser Char Char
pQuote = pSym '"'

-- | Parses whitespace (spaces, newlines, returns and tabs).
pWhiteSpace :: Parser Char [Char]
pWhiteSpace = pList $ (pAnySym [' ', '\n', '\r', '\t'])

-- | A parser for alphanumeric and special characters.
pAlphaNum :: Parser Char Char
pAlphaNum = pAnySym (['a'..'z']++['A'..'Z']++['0'..'9']++":;.-_+[]()|/?~!@#$%^&*\\")

-- | A parser extending 'pAlphaNum' with { and }.
pAlphaNumWithBrace :: Parser Char Char
pAlphaNumWithBrace = pAlphaNum <|> pAnySym "{}"

-- | Possibly quoted parser p or parser q.
pEitherQuotedOrNot :: Parser Char a -> Parser Char a -> Parser Char a
pEitherQuotedOrNot p q = pQuote *> p <* pQuote <|> q

-- | Possibly quoted parser p or p.
pMaybeQuoted :: Parser Char a -> Parser Char a
pMaybeQuoted p = pQuote *> p <* pQuote <|> p

-- | Parser with whitespace at the beginning and/or end or none at all.
pWrapWhitespace :: Parser Char a -> Parser Char a
pWrapWhitespace p = pWhiteSpace *> p <|>  pWhiteSpace *> p <* pWhiteSpace <|> p <* pWhiteSpace <|> p

-- | Parser of a 'pAlphaNum' with spaces/comma's.
pAnyWordWithSpaces :: Parser Char [Char]
pAnyWordWithSpaces = pList $ pAlphaNum <|> pSym ' ' <|> pSym ','

-- | Parser with spaces and braces.
pAnyWordWithSpacesAndBraces :: Parser Char [Char]
pAnyWordWithSpacesAndBraces = pList $ pAlphaNumWithBrace <|> pSym ' ' <|> pSym ','

-- | Either quoted parser with braces or a word with spaces.
pMQWordWithSpaces :: Parser Char [Char]
pMQWordWithSpaces = pEitherQuotedOrNot pAnyWordWithSpacesAndBraces pAnyWordWithSpaces

-- | Parse any 'pAlphaNum' word.
pAnyWord :: Parser Char [Char]
pAnyWord = pList1 $ pAlphaNum
