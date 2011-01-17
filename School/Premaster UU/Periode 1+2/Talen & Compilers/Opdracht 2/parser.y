{
module Parser where
import Token
}

%name parseArrow
%tokentype { Token }
%error { parseError }

%token 
      '.'             { Dot }
      ','             { Comma }
      ';'             { Semicolon }
      '_'             { Underscore }
      '->'            { ArrowTo }
      go              { Go }
      take            { Take }
      mark            { Mark }
      nothing         { DoNothing }
      turn            { Turn }
      case            { Case }
      of              { Of }
      end             { End }
      left            { ToLeft }
      right           { ToRight }
      front           { Front }
      empty           { Empty }
      lambda          { Lambda }
      debris          { Debris }
      asteroid        { Asteroid }
      boundary        { Boundary }
      ident           { Ident $$ }
      
%%

Program :: {[Rule]}  : {- empty -}       { [] }
                     | Rule Program      { $1 : $2 }

Rule        : ident '->' Cmds '.' { ($1,$3) }

Cmds :: {[Cmd]} : {- empty -}   { [] }
                | Cmd           { $1 : [] }
                | Cmd ',' Cmds  { $1 : $3 }

Cmd         : go                { CmdGo }
            | take              { CmdTake }
            | mark              { CmdMark }
            | nothing           { CmdNothing }
            | turn Direction    { CmdTurn $2 }
            | case Direction of Alts end { CmdCase $2 $4 }
            | ident             { CmdIdent $1 }

Direction   : left              { DirLeft }
            | right             { DirRight }
            | front             { DirFront }

Alts :: {[Alt]} : {- empty -}   { [] }
                | Alt           { $1 : [] }
                | Alt ';' Alts  { $1 : $3 }

Alt         : Pat '->' Cmds     { ($1,$3) }

Pat         : empty             { PatEmpty }
            | lambda            { PatLambda }
            | debris            { PatDebris }
            | asteroid          { PatAsteroid }
            | boundary          { PatBoundary }
            | '_'               { PatUnderscore }
            

{

parseError :: [Token] -> a
parseError _ = error "Parse error"
    
type Program = [Rule]
type Rule = (String,Cmds)
type Cmds = [Cmd]
data Cmd = CmdGo | CmdTake | CmdMark | CmdNothing | CmdTurn Direction | CmdCase Direction Alts | CmdIdent String deriving (Show,Eq)
data Direction = DirLeft | DirRight | DirFront deriving (Show,Eq)
type Alts = [Alt]
type Alt = (Pat,Cmds)
data Pat = PatEmpty | PatLambda | PatDebris | PatAsteroid | PatBoundary | PatUnderscore deriving (Show,Eq)
    
}