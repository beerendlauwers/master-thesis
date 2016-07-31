#define MAXUSERS      4
#define MAXMESSAGES   1
#define MSGLIMIT      2

/*
 * sender constraint content
 */
chan inbox[MAXUSERS] = [MAXMESSAGES] of { byte,byte,byte };
chan outbox[MAXUSERS] = [MAXMESSAGES] of { byte,byte,byte };
byte uniqueContent = 0;

/*
 * userDevice reads from the inbox, (might forward -> outbox)
 * or sends from the outbox,
 * or creates a new mesage and adds to the outbox,
 * or skip.
 */
proctype userDevice (byte user){
byte inSender;
byte inConstraint=0;
byte inContent=0;
byte outSender=0;
byte outConstraint=0;
byte outContent=0;

do
/* READ AN INBOX MESSAGE */
:: nempty(inbox[user]) -> 
R0: atomic { 
   inbox[ user ] ? inSender, inConstraint, inContent; 
   if
   :: (inConstraint > 0 && user > 0) ->
	  if
	  :: nfull(outbox[user]) -> outbox[user] ! inSender, inConstraint, inContent;
      :: full(outbox[user]) ->   inbox[user] ! inSender, inConstraint, inContent;
	  fi
   :: else skip;
   fi;
   /*acknowledge to sender */
   }	
/*CREATE A NEW MESSAGE TO OUTBOX */
:: (empty(inbox[user]) && empty(outbox[user]) && user > 0 && uniqueContent < MSGLIMIT) ->  
	 atomic{ if
     :: uniqueContent < MSGLIMIT -> outbox[ user ] ! user, 1, uniqueContent; d_step{ uniqueContent=uniqueContent+1; } /*outbox is not full, so this will not block.*/
	 :: uniqueContent < MSGLIMIT -> outbox[ user ] ! user, 2, uniqueContent; d_step{ uniqueContent=uniqueContent+1; } /*outbox is not full, so this will not block.*/
     :: else skip;
     fi; }
   
/*SEND AN OUTBOX MESSAGE*/
:: nempty(outbox[user]) ->
   atomic{
   outbox[ user ] ? outSender, outConstraint, outContent;
   }
   if
   :: (nfull(inbox[(outSender+1) % MAXUSERS]) && nfull(inbox[(outSender+2) % MAXUSERS])) && outConstraint > 1 -> 
S0:   if
      :: inSender != ((user+1) % MAXUSERS) -> atomic{ inbox[(outSender+1) % MAXUSERS] ! outSender, (outConstraint-1), outContent; /*follower1*/ }
      :: else skip;
      fi;
S1:   if
      :: inSender != ((user+2) % MAXUSERS) -> atomic{ inbox[(outSender+2) % MAXUSERS] ! outSender, (outConstraint-1), outContent; /*follower2*/ }
      :: else skip;
	  fi
   :: atomic{outbox[ user ] ! outSender, outConstraint, outContent; }
   fi;
:: timeout -> break;
od
}

byte vi = 0;	
init {
	byte i = 0;
	atomic{
	do
	:: (vi < 5) -> vi++;
	:: (vi > 1) -> vi--;
	:: break;
	od;
    
	do
	:: i < MAXUSERS -> run userDevice(i); i++;
	:: else break;
	od
	}
}

/* vi = {1,2,3,4} */
ltl fo { (
 (
 ([] (( (vi > 1) && 
        (userDevice[vi]@S0) && 
		(userDevice[vi]:_3_outConstraint > 1 ) 
 -> 
 ( <> ( (userDevice[((vi+1)%MAXUSERS)]@R0) && 
        (userDevice[((vi+1)%MAXUSERS)]:_3_inContent == userDevice[vi]:_3_outContent) )))))
 )&&(
 ([] (( (vi > 1) && (userDevice[vi]@S1) && 
        (userDevice[vi]:_3_outConstraint > 1 ) 
 -> 
 ( <> ( (userDevice[((vi+2)%MAXUSERS)]@R0) && 
        (userDevice[((vi+2)%MAXUSERS)]:_3_inContent == userDevice[vi]:_3_outContent) )))))
 )
)
}
ltl fo2 { ((
 ([] (((vi > 0) && 
       userDevice[vi]@S0 &&
	   (userDevice[vi]:_3_outConstraint == 2 ) &&
	   (((vi+1)%MAXUSERS) > 0) 
	  ) ->
	  (<> ((userDevice[(((vi+1)%MAXUSERS)+1%MAXUSERS)]@R0 &&
	        userDevice[(((vi+1)%MAXUSERS)+1%MAXUSERS)]:_3_inContent == userDevice[vi]:_3_outContent) && 
	       (userDevice[(((vi+1)%MAXUSERS)+2%MAXUSERS)]@R0 &&
	        userDevice[(((vi+1)%MAXUSERS)+2%MAXUSERS)]:_3_inContent == userDevice[vi]:_3_outContent))
	 )))
 &&
 ([] (((vi > 0) && 
       userDevice[vi]@S0 &&
	   (userDevice[vi]:_3_outConstraint == 2 ) &&
	   (((vi+2)%MAXUSERS) > 0) 
	  ) ->
	  (<>((userDevice[(((vi+2)%MAXUSERS)+1%MAXUSERS)]@R0 &&
	       userDevice[(((vi+2)%MAXUSERS)+1%MAXUSERS)]:_3_inContent == userDevice[vi]:_3_outContent) && 
	      (userDevice[(((vi+2)%MAXUSERS)+2%MAXUSERS)]@R0 &&
	       userDevice[(((vi+2)%MAXUSERS)+2%MAXUSERS)]:_3_inContent == userDevice[vi]:_3_outContent))
	 )))
))}