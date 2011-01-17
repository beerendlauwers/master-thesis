{
module Parser where
import Token
}

%name arrow
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

Program :: {[Rule]}  : Rule Program      { $1 : $2 }

Rule        : Identifier '->' Cmds '.' { ARule $1 $3 }

Cmds :: {[Cmd]}  : Cmd ',' Cmds      { $1 : $3 }

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

Alts :: {[Alt]}        : Alt ';' Alts      { $1 : $3 }

Alt         : Pat '->' Cmds     { Alt $1 $3 }

Pat         : empty             { PatEmpty }
            | lambda            { PatLambda }
            | debris            { PatDebris }
            | asteroid          { PatAsteroid }
            | boundary          { PatBoundary }
            | '_'               { PatUnderscore }
            
Identifier  : ident             { Identifier $1 }

{

-- SK combinatoren nachecken



parseError :: [Token] -> a
parseError _ = error "Parse error"
    
type Program = [Rule]
data Rule = ARule Identifier Cmds
type Cmds = [Cmd]
data Cmd = CmdGo | CmdTake | CmdMark | CmdNothing | CmdTurn Direction | CmdCase Direction Alts | CmdIdent String
data Direction = DirLeft | DirRight | DirFront
type Alts = [Alt]
data Alt = Alt Pat Cmds
data Pat = PatEmpty | PatLambda | PatDebris | PatAsteroid | PatBoundary | PatUnderscore
data Identifier = Identifier String
    
}