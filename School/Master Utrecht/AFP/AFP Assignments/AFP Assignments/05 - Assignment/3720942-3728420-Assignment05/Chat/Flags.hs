module Chat.Flags where

data Flag = Server | Client Host Nick deriving (Ord,Eq,Show)
type Host = String
type Nick = String