{
module Token where
}

%wrapper "basic"

$digit = 0-9			-- digits
$letter = [a-zA-Z]		-- alphabetic characters

tokens :-

  \.                      { \s -> Dot }
  \,                      { \s -> Comma }
  \;                      { \s -> Semicolon }
  \_                      { \s -> Underscore }
  "->"                    { \s -> ArrowTo }
  "go"                    { \s -> Go }
  "take"                  { \s -> Take }
  "mark"                  { \s -> Mark }
  "nothing"               { \s -> DoNothing }
  "turn"                  { \s -> Turn }
  "case"                  { \s -> Case }
  "of"                    { \s -> Of }
  "end"                   { \s -> End }
  "left"                  { \s -> ToLeft }
  "right"                 { \s -> ToRight }
  "front"                 { \s -> Front }
  "Empty"                 { \s -> Empty }
  "Lambda"                { \s -> Lambda }
  "Debris"                { \s -> Debris }
  "Asteroid"              { \s -> Asteroid }
  "Boundary"              { \s -> Boundary }
  [$letter $digit \+ \-]+ { \s -> Ident s }
  $white+				;
  "--".*				;

{
-- Each action has type :: String -> Token

-- The token type:
data Token =
	ArrowTo | Dot | Comma | Semicolon | Underscore |
    Go | Take | Mark | DoNothing |
    Turn | Case | Of | End |
    ToLeft | ToRight | Front |
    Empty | Lambda | Debris | Asteroid | Boundary |
    Ident String
	deriving (Eq,Show)

lexArrow :: String -> [Token]
lexArrow = alexScanTokens
}