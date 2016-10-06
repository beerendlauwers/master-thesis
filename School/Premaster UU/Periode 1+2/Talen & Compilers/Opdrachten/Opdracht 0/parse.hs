module Parse where
import Char

type Parser a = String -> [(a, String)]

pLetter :: Char -> Parser Char
pLetter c [] = []
pLetter c (x:xs) | x == c = [(x, xs)]
                 | otherwise = [ ]

pLettera = pLetter 'a'

pToken :: String -> Parser String
pToken t xs | t == take n xs = [(t, drop n xs)]
            | otherwise = [ ]
            where n = length t
            
pSatisfy :: (Char -> Bool) -> Parser Char
pSatisfy p [] = []
pSatisfy p (x:xs) = if p x then [(x, xs)] else []

(<|>) :: Parser a -> Parser a -> Parser a
(p1 <|> p2) xs = p1 xs ++ p2 xs

(<*>) :: Parser (b -> a) -> Parser b -> Parser a
(p <*> q) inp = [ (pv qv, rrinp) | (pv, rinp) <- p inp
                                 , (qv, rrinp) <- q rinp]
pure v = \inp -> [ (v, inp) ]

(<$>) :: (a -> b) -> Parser a -> Parser b
(f <$> p) xs = [ (f v, ys) | ( v, ys) <- p xs]

infixl 5 <*>
infixr 3 <|>
infix  7 <$>


pJust :: Parser a -> Parser a
pJust p xs = [ (v, "") | (v, ys) <- p xs, ys == ""]

pSucceed v input = [ (v, input) ]
p `opt` v = p <|> pSucceed v
pFail input = []

-- Enkele voorbeelden

checkHaakjes = pJust haakjes

haakjes = ( (\_ h1 _ h2 -> (1 + h1) `max` h2) <$> pLetter '(' <*> haakjes <*> pLetter ')' <*> haakjes) <|> pSucceed 0

infixl 5 <*
infixl 7 <$
f <$ p = const <$> pSucceed f <*> p
p <* q = const <$> p <*> q
p *> q = id <$ p <*> q

haakjes' = ( max . (1+) <$ pLetter '(' <*> haakjes' <* pLetter ')' <*> haakjes') `opt` 0

pParens p = pLetter '(' *> p <* pLetter ')'
pDigit = pSatisfy (\x -> ord x >= ord '0' && ord x <= ord '9')
haakjes'' = (max <$> ((1+) <$> pParens haakjes'') <*> haakjes'') `opt` 0
enkelHaakjes = pJust haakjes''

