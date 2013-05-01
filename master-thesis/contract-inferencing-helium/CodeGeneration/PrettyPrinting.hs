module Domain.FP.CodeGeneration.PrettyPrinting where

import qualified Common.Library as CL (build)
import Text.PrettyPrint as PP
import qualified Domain.FP.Helium as Helium
import qualified Domain.FP.Views as Views
import Domain.FP.SyntaxWithRanges
import Domain.FP.Views ()

class Pretty a where
  pprint :: a -> PP.Doc

instance Pretty a => Pretty (Maybe a) where
  pprint Nothing   = PP.text "Nothing"
  pprint (Just p)  = PP.parens $ PP.text "Just" PP.<+> PP.parens (pprint p)

instance Pretty a => Pretty [a] where
  pprint = foldr (\x xs -> pprint x $+$ xs) PP.empty

instance (Pretty a, Pretty b) => Pretty (a, b) where
  pprint (l, r) = PP.parens $ pprint l PP.<> PP.comma PP.<+> pprint r

instance Pretty Int where
  pprint = PP.int

instance Pretty Char where
  pprint = PP.char

instance Pretty Bool where
  pprint = PP.text . show

instance Pretty NameR where
  pprint (IdentR n _)    = PP.text n
  pprint (OperatorR n _) = PP.text n
  pprint (SpecialR n _)  = PP.text n

instance Pretty ModuleR where
  pprint = PP.text . Helium.ppModule . CL.build Views.heliumWithRangesView

instance Pretty DeclR where
  pprint = PP.text . Helium.ppDeclaration . CL.build Views.heliumWithRangesView

instance Pretty ExprR where
  pprint = PP.text . Helium.ppExpression . CL.build Views.heliumWithRangesView

