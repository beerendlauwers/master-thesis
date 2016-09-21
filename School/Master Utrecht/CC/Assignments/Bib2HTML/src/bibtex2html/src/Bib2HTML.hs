-- |This module checks a 'BibTex' database for correctness and outputs warning messages when it encounters inconsistensies. A syntactically valid, but semantically incorrect BibTex file does not halt the program, but does provide highly specific messages. After checking, the 'BibTex' database is converted into an HTML 'ATerm'. The module's 'main' function uses a 'Component' wrapped in 'ioWrap' for the pipe-passing mode, and provides the 'ioCheckBibTex' function for checking in file mode.
module Bib2HTML where

import BibTex
import CCO.Tree
import qualified Data.Set as S
import System.IO
import Data.List
import CCO.Component
import CCO.Feedback
import Control.Arrow
import System.Exit      (exitWith, ExitCode (ExitSuccess), exitFailure)

-- |This calls 'ioWrap' 'pipeline'.
main :: IO()
main = ioWrap pipeline

-- *Validation Code

-- **Required and optional attribute generation

-- |Type synonym for a generator of a list of 'AttrType's for validation. 
type ValidationListGen = (EntryType -> [AttrType])

{-|Given an 'EntryType', produce a list of required fields for that 'EntryType'. Based upon <http://nwalsh.com/tex/texhelp/bibtx-7.html>.

NOTE: For the entry types, we did not take into account the following:

     * The 'Book' Entry type requires either the 'Editor' or the 'Author' attribute type. We only put 'Author' as a required field, and 'Editor' as an optional field.
     
     * The 'Inbook' Entry type does the same, as well as allowing the 'Chapter' and / or 'Pages' attribute type. We put 'Chapter' as a required field, and 'Pages' as an optional field.
-}
reqFields :: ValidationListGen
reqFields Article = [Author, Title, Journal, Year]
reqFields Book = [Author, Title, Publisher, Year] -- We excluded Editor here!
reqFields Booklet = [Title]
reqFields Conference = [Author, Title, Booktitle, Year] -- We excluded Editor and Pages here!
reqFields Inbook = [Author, Title, Chapter, Publisher, Year] 
reqFields Incollection = [Author, Title, Booktitle, Year]
reqFields Inproceedings = [Author, Title, Booktitle, Year]
reqFields Manual = [Title]
reqFields Mastersthesis = [Author, Title, School, Year]
reqFields Misc = []
reqFields Phdthesis = [Author, Title, School, Year]
reqFields Proceedings = [Title, Year]
reqFields Techreport = [Author, Title, Institution, Year]
reqFields Unpublished = [Author, Title, Note]
reqFields _ = []

-- |Given an 'EntryType', produce a list of optional fields for that 'EntryType'. Based upon <http://nwalsh.com/tex/texhelp/bibtx-7.html>.
optFields :: ValidationListGen
optFields Article = [Volume, Number, Pages, Month, Note, Key]
optFields Book = [Editor, Volume, Series, Address, Edition, Month, Note, Key]
optFields Booklet = [Author, Howpublished, Address, Year, Month, Note, Key]
optFields Conference = [Editor, Pages, Organization, Publisher, Address, Month, Note, Key]
optFields Inbook = [Editor, Pages, Volume, Series, Address, Edition, Month, Note, Key]
optFields Incollection = [Editor, Pages, Organization, Publisher, Address, Month, Note, Key]
optFields Inproceedings = [Editor, Pages, Organization, Publisher, Address, Month, Note, Key]
optFields Manual = [Author, Organization, Address, Edition, Year, Month, Note, Key]
optFields Mastersthesis = [Address, Month, Note, Key]
optFields Misc = [Author, Title, Howpublished, Year, Month, Note, Key]
optFields Phdthesis = [Address, Month, Note, Key]
optFields Proceedings = [Editor, Publisher, Organization, Address, Month, Note, Key]
optFields Techreport = [Type, Number, Address, Month, Note, Key]
optFields Unpublished = [Month,Year, Key]
optFields _ = []

-- |Type synonym for a function that takes some information for generating a meaningful warning message.
type WarningGenerator = String -> EntryType -> AttrType -> String

-- **Warning generation

-- |Generates warnings for missing required attributes.
reqNotPresent :: WarningGenerator
reqNotPresent s entry attr = "ERROR: " ++ show attr ++ " is a required entry attribute in " ++ show entry ++ " \"" ++ s ++ "\"."

-- |Generates warnings for missing optional attributes.
optNotPresent :: WarningGenerator
optNotPresent s entry attr = "WARNING: " ++ show entry ++ " \"" ++ s ++ "\" was not supplied with the optional argument " ++ show attr ++ "."

-- |Generates warnings for irrelevant (not required and not optional) attributes.
unusedAttrs :: WarningGenerator
unusedAttrs s entry attr = "WARNING: " ++ show attr ++ " is not used in the entry " ++ show entry  ++ " \"" ++ s ++ "\" and will be ignored."

-- Code for abstracting from attribute type checking.

-- **Attribute type checking

-- |Given a list of 'AttrType's and another 'AttrType', check if it is an element of the first argument and return an accoridng tuple.
check :: [AttrType]      -- ^list of attributes
      -> AttrType        -- ^attribute that will be checked if it is in the list
      -> (Bool,AttrType) -- ^resulting tuple
check list x = if not $ x `elem` list then (False, x) else (True, x)

-- |Type synonym for a function that checks the validity of an 'EntryType' and its 'AttrType's.
type CheckFunction = EntryType -> [AttrType] -> [(Bool,AttrType)]

-- |Abstracts over checking.
checkFor :: ValidationListGen -> CheckFunction
checkFor g entry list = map (check list) (g entry)

-- |These functions check for required fields, optional fields and unused fields, respectively.
checkForReq, checkForOpt, checkForUnused :: CheckFunction
checkForReq = checkFor reqFields
checkForOpt = checkFor optFields 
checkForUnused entry = map (check (reqFields entry ++ optFields entry))

-- Code for updating the attribute type list of an entry.

-- **Clean-up functions

-- |Converts a list to a 'Set' and back again to get rid of doubles in the list.
removeDoubles :: (Ord a) => [a] -> [a]
removeDoubles = S.toList.S.fromList

-- |Given a list of tuples and a list of 'Attr's, remove all 'Attr's whose 'AttrType' is coupled with 'False' in the tuple.
removeUnused :: [(Bool,AttrType)] -> [Attr] -> [Attr]
removeUnused list attrs = concat $ map extractAttr list
 where
    extractAttr :: (Bool,AttrType) -> [Attr]
    extractAttr (x,atype) = if x then (lookupAttr atype attrs) : [] else []

-- |Given an 'AttrType' and a list of 'Attr's, find the corresponding 'Attr' value.
lookupAttr :: AttrType -> [Attr] -> Attr
lookupAttr atype ((Attr t v):xs) = if atype == t then Attr t v else lookupAttr atype xs
lookupAttr atype [] = (Attr atype "VALUE_NOT_FOUND_IN_LOOKUP")

-- Code for printing all the validation messages.

-- **Printing functions

-- |/Unused/. Checks for required attributes and halts the program if there are missing required attributes.
checkForErrors :: (Monad m) => String -> EntryType -> [AttrType] -> m ()
checkForErrors s e attrs = 
 let result = checkForReq e attrs
 in if not $ all (==True) $ map fst result then error $ "Missing required attributes for entry " ++ show e ++ " \"" ++ s ++ "\"." else return () 

-- |Abstracts over the printing of 'String's generated by a 'WarningGenerator'.
printIssues :: WarningGenerator -> String -> EntryType -> [(Bool,AttrType)] -> Feedback ()
printIssues f s e ((False,x):xs) = 
 do trace_ $ f s e x
    printIssues f s e xs
printIssues f s e ((True,_):xs) = 
 do printIssues f s e xs
printIssues _ _ _ _ = 
 do return ()
 
-- |Abstracts over attribute checking and warning message printing.
printMessages :: CheckFunction -> WarningGenerator -> String -> EntryType -> [AttrType] -> Feedback ()
printMessages f g s entry attrs =
 let checkedList = f entry attrs
 in printIssues g s entry checkedList

-- |These functions print warning messages for required fields, optional fields and unused fields, respectively.
printReqErrors, printOptWarnings, printUnusedWarnings :: String -> EntryType -> [AttrType] -> Feedback ()
printReqErrors = printMessages checkForReq reqNotPresent
printOptWarnings = printMessages checkForOpt optNotPresent
printUnusedWarnings = printMessages checkForUnused unusedAttrs

-- Code for getting the attribute type list from the entry and inserting an updated list.

-- **Getting/Setting AttrTypes

-- |Extracts the 'AttrType's from a list of 'Attr's. 
extractAttrTypes :: [Attr] -> [AttrType]
extractAttrTypes = map (\(Attr atype _) -> atype)

-- |Recombines a list of 'AttrType's with their corresponding 'Attr's. Note that we could have used a 'Lens' datatype here.
recombineAttrTypes :: [Attr] -> [AttrType] -> [Attr]
recombineAttrTypes attrs = map (\x -> lookupAttr x attrs)

-- Code for validation and ordering.

-- **Validation And Ordering

-- |Checks the attributes of an 'Entry' for required, optional and unused attributes, and removes duplicate attributes.
checkAttributes :: Entry -> Feedback Entry
checkAttributes (Entry e s attrs) = 
 do let attrTypes = extractAttrTypes attrs
    let undoubleList = removeDoubles attrTypes
    let allFunctions = [printReqErrors, printOptWarnings, printUnusedWarnings]
    mapM_ (\func -> func s e undoubleList) allFunctions
    let finalAttrs = removeUnused (checkForUnused e undoubleList) attrs
    return $ Entry e s finalAttrs

-- Should we really halt the program when validation errors are found?
-- |/Unused/. Checks for required attributes and halts the program if there are missing required attributes.
checkErrors :: Entry -> Feedback ()
checkErrors (Entry e s attrs) = 
 do let attrTypes = extractAttrTypes attrs
    let undoubleList = removeDoubles attrTypes
    checkForErrors s e undoubleList
    return ()
    
-- |Orders attributes according to their order of appearance in the definition of 'AttrType'.
orderAttributes :: [Attr] -> [Attr]
orderAttributes attrs = let sorted = sort $ extractAttrTypes attrs
                        in recombineAttrTypes attrs sorted

-- |Orders entries according to their order of appearance in the definition of 'EntryType', currently alphabetically. 
orderEntries :: [Entry] -> [Entry]
orderEntries es = let sorted = sortBy sortEntries es
                  in map (\(Entry t v xs) -> Entry t v (orderAttributes xs)) sorted 
 where
    sortEntries (Entry t1 _ _) (Entry t2 _ _) = compare t1 t2

-- *IO Monad Code
    
-- |Use this to check a 'BibTex' database in the 'IO' Monad.
ioCheckBibTex :: StrBibTex -> IO ATerm
ioCheckBibTex strbibtex = do
 let bibTexATerm = fromTree strbibtex
 let feedback = (toTree bibTexATerm)::Feedback BibTex
 y <- runFeedback feedback 1 1 stderr
 case y of
  Nothing -> error "Unable to convert parsed BibTex file to a valid BibTex database."
  Just (BibTex entries) -> do let mapFeedback = mapM checkAttributes entries
                              z <- runFeedback mapFeedback 1 1 stderr
                              case z of
                                Nothing -> error "Error while checking BibTex database."
                                Just entries -> do let finalBibTex = BibTex $ orderEntries entries
                                                   return $ bibTex2HTML finalBibTex

-- *Component Code

-- |Converts a 'String' to an 'ATerm' using 'CCO.Tree.parser'.
convertToAterm :: Component String ATerm
convertToAterm = CCO.Tree.parser

-- |Converts an 'ATerm' to a 'BibTex' database using 'toTree'.
convertToBibTex :: Component ATerm BibTex
convertToBibTex = component toTree

-- |Checks a 'BibTex' database for validity.
checkBibTex :: Component BibTex BibTex
checkBibTex = component $ \(BibTex entries) -> do
                trace_ "Validating..."
                mapM checkAttributes entries
                return $ BibTex entries
 
-- |Sorts a 'Bibtex' database's 'Entry' and 'Attr' elements.
sortBibTex :: Component BibTex BibTex
sortBibTex = component $ \(BibTex entries) -> do 
                trace_ "Sorting..."
                return $ BibTex (orderEntries entries)
                
-- |Converts a 'BibTex' database to an HTML 'ATerm', which is then converted to a 'String' using 'show'.
toHTMLBibTex :: Component BibTex String
toHTMLBibTex = component $ \bibtex -> do
                trace_ "Converting to HTML"
                let htmlATerm = bibTex2HTML bibtex
                return $ show htmlATerm

-- |A 'Component' pipeline that binds all the 'Component's mentioned above.
pipeline :: Component String String
pipeline = convertToAterm >>> convertToBibTex >>> checkBibTex >>> sortBibTex >>> toHTMLBibTex

-- *HTML Generation

-- |Converts a 'BibTex' database to an HTML 'ATerm'.
bibTex2HTML :: BibTex -> ATerm
bibTex2HTML b = putATermInBody (bibTex2HTML' b)
 where
  putATermInBody :: [ATerm] -> ATerm
  putATermInBody a = (App "html" [(App "head" [(App "title" [(String "Bibliography")])]), (App "body" a)])
  bibTex2HTML' :: BibTex -> [ATerm]
  bibTex2HTML' (BibTex es) = (map createLink es) ++ (hrATerm:([createEntries es]))
  createEntries :: [Entry] -> ATerm
  createEntries es = createTable $ (map createEntry es)
  createEntry :: Entry -> ATerm
  createEntry e = createTableRow $ [(createTableField $ [createName e] ), (createTableField (createEntryText e))]
  hrATerm ::ATerm
  hrATerm = (App "hr" [])

-- |Generates an \<a\> tag from an 'Entry'.
createLink :: Entry -> ATerm
createLink (Entry _ ti _) = (Ann (App "a" [(App "href" [(String ("#"++ti))])]) [(String ("["++ti++"]"))])

-- |Generates a name from an 'Entry'.
createName :: Entry -> ATerm
createName (Entry _ ti _) = (Ann (App "a" [(App "name" [(String ti)])]) [(String ("["++ti++"]"))])

-- |Generates a \<table\> tag for a list of 'ATerm's.
createTable :: [ATerm] -> ATerm
createTable at = (Ann (App "table" [(App "border" [(String "0")])]) at)

-- |Generates a \<tr\> tag for a list of 'ATerm's.
createTableRow :: [ATerm] -> ATerm
createTableRow at = (Ann (App "tr" [(App "valign" [String "top"])]) at)

-- |Generates a \<td\> tag for a list of 'ATerm's.
createTableField :: [ATerm] -> ATerm
createTableField at = (App "td" at)

-- |Formats an 'Entry'.
createEntryText :: Entry -> [ATerm]
createEntryText (Entry ty ti attrs) = concat $ map (Bib2HTML.find attrs) sorting 
 where sorting = attrTypes

-- |Search through the given list of 'Attr's to find a corresponding 'find'' function, and call it.
find :: [Attr] -> AttrType -> [ATerm]
find [] _ = []
find ((Attr t' v):ats) t = if (t == t') then (find' t v) else (Bib2HTML.find ats t)

-- |Formats an 'AttrValue'.
find' :: AttrType -> AttrValue -> [ATerm]
find' Editor v = [(String ("In: "++v++". "))]
find' Title v = [(App "em" [(String (v++". "))])]
find' Booktitle v = [(App "em" [(String (v++". "))])]
find' Journal v = commaFind v
find' Month v = commaFind v
find' Note v = [(String ("'"++v++"'"))]
find' Pages v = [(String ("Pages "++v++". "))]
find' Organization v = commaFind v
find' _ v = defaultFind v

-- |Common formats.
commaFind, defaultFind :: String -> [ATerm]
commaFind v = [(String (v++", "))]
defaultFind v = [(String (v++". "))]