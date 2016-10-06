import Test.QuickCheck
import Data.Char
import qualified PGN as T
import qualified Jeroen.PGN as S
import ParseLib.Abstract
import Control.Monad

--SAN

genRank::Gen T.Rank
genRank = choose (1,8)

genFile::Gen T.File
genFile = do i <- choose (97,104)
             return (chr i)

instance Arbitrary T.Piece where
    arbitrary = oneof . map return $ [T.Rook,T.Bishop,T.Queen,T.King,T.Knight,T.Pawn]

instance Arbitrary T.Check where
    arbitrary = oneof . map return $ [T.Check,T.CheckMate,T.NoCheck]
    
instance Arbitrary T.Promotion where
    arbitrary = oneof [return T.NoPromotion, liftM T.Promotion arbitrary]

instance Arbitrary T.Capture where
    arbitrary = oneof [return T.Cap,return T.NoCap]

instance Arbitrary T.Square where
    arbitrary = liftM2 T.Square genFile genRank

instance Arbitrary T.DisAmbi where
    arbitrary = oneof [return T.NoDisAmbi, liftM T.FileDisAmbi genFile, {-liftM T.RankDisAmbi genRank,-} liftM T.SquareDisAmbi arbitrary]

instance Arbitrary T.Move where
    arbitrary = frequency [(50,genMove),(1,return T.KCastle),(1,return T.QCastle)]
       where genMove = do     piece <- arbitrary
                              disamb <- arbitrary                         
                              cap <- arbitrary
                              sq <- arbitrary
                              prom <- arbitrary
                              chk <- arbitrary
                              return (T.Move piece disamb cap sq prom chk)          

parseResult::Parser a b -> [a] -> b
parseResult p = fst.head. parse p

propMoveParseAll mv = any (null.snd) (parse S.parseMove (T.printMove mv))
               where types = mv::T.Move

propMoveReproduce mv = T.printMove mv == S.printMove ( parseResult S.parseMove ( T.printMove mv))
               where types = mv::T.Move

propPromotionCheck mv = S.promotionCheck (parseResult S.parseMove (T.printMove mv)) == T.promotionCheck mv

--PGN

instance Arbitrary T.Termination where
     arbitrary = oneof . map return $ [T.WhiteWins,T.BlackWins,T.Draw,T.NoEnd]

instance Arbitrary T.Element where
     arbitrary = sized eles'
          where eles'::Int -> Gen T.Element
                eles' 0 = ele
                eles' n | n > 0 = frequency 
                         [(50,ele), 
                         (1,liftM T.Variation (resize nsq (Test.QuickCheck.listOf (eles' nsq))))]
                         where nsq = fromIntegral (round (sqrt (fromIntegral n)))
                ele = liftM3 T.Element (liftM (fmap abs) arbitrary) arbitrary (liftM (fmap (map abs)) arbitrary)

instance Arbitrary T.MoveText where
     arbitrary = liftM2 T.MoveText arbitrary arbitrary

filterany::[a->Bool] -> [a] -> [a]
filterany lsp = filter (\x -> any (\y -> y x) lsp)

filterall::[a->Bool] -> [a] -> [a]
filterall lsp = filter (\x -> all (\y -> y x) lsp)

chars::[Char]
chars = map chr [32..255]

{-instance Arbitrary T.Tag where
     arbitrary = do  name <- liftM2 (:) (oneof ( map return ( filterany [isDigit] chars))) 
                            (Control.Monad.sequence (Test.QuickCheck.listOf1 ( map return ( filterany ([isLetter,isDigit]++(map (==) "'+#=:-/")) chars))))
{-               string <- Test.QuickCheck.listOf . map return $ filter (allOK [isPrint, not.('\"'==), not.('\\'==)]) (map (\x -> [chr x]) [32..256]))-}
               return (T.Tag (name,""))-}

instance Arbitrary T.Game where
     arbitrary = do     --tags <- arbitrary
                   mov <- arbitrary
                   return (T.Game [] mov)

instance Arbitrary T.PGN where
     arbitrary = liftM T.PGN (sized $ \n -> resize (round (sqrt (fromIntegral n))) (listOf1 arbitrary))

propPGNParseAll pgn = any (null.snd) (parse S.parsePGN (T.printPGN pgn))
               where types = pgn::T.PGN

propPGNPrintOK pgn = T.printPGN pgn == T.printPGN (parseResult T.parsePGN (S.printPGN (parseResult S.parsePGN (T.printPGN pgn))))
               where types = pgn::T.PGN

main :: IO ()
main = mapM_ (\(l, p) -> putStr ("[" ++ l ++ "] ") >> quickCheck p)
  [ ("Move Parser Complete  ", property propMoveParseAll             )
  , ("Move Reproduce Same   ", property propMoveReproduce            )
  , ("Promotion Check       ", property propPromotionCheck           )
  , ("PGN Parser Complete   ", property propPGNParseAll              )
  , ("PGN Print OK          ", property propPGNPrintOK               )
  ]
