#define MAXUSERS      4
#define MAXMESSAGES   2
#define MSGLIMIT      2
/*
 * sender constraint content
 */
chan inbox[MAXUSERS] = [MAXMESSAGES] of { byte,byte,byte };
chan outbox[MAXUSERS] = [MAXMESSAGES] of { byte,byte,byte };
byte msgCount;
byte uniqueContent;

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
   inbox[ user ] ? inSender, inConstraint, inContent; msgCount=msgCount-1; 
   if
   :: (inConstraint > 0 && user > 0) ->
	  if
	  :: nfull(outbox[user]) -> outbox[user] ! inSender, inConstraint, inContent; msgCount=msgCount+1;
      :: full(outbox[user]) ->   inbox[user] ! inSender, inConstraint, inContent; msgCount=msgCount+1; 
	  fi
   :: else skip;
   fi;
   /*acknowledge to sender */
   }	
/*CREATE A NEW MESSAGE TO OUTBOX */
:: (empty(inbox[user]) && empty(outbox[user]) && user > 0) ->  
	 atomic{ if
     :: uniqueContent < MSGLIMIT -> outbox[ user ] ! user, 1, uniqueContent; uniqueContent=uniqueContent+1; msgCount=msgCount+1 /*outbox is not full, so this will not block.*/
	 :: uniqueContent < MSGLIMIT -> outbox[ user ] ! user, 2, uniqueContent; uniqueContent=uniqueContent+1; msgCount=msgCount+1 /*outbox is not full, so this will not block.*/
     :: else skip;
     fi; }
   
/*SEND AN OUTBOX MESSAGE*/
:: nempty(outbox[user]) ->
   atomic{
   outbox[ user ] ? outSender, outConstraint, outContent; msgCount=msgCount-1;
   }
   if
   :: (nfull(inbox[(outSender+1) % MAXUSERS]) && nfull(inbox[(outSender+2) % MAXUSERS])) -> 
S0:   if
      :: inSender != ((user+1) % MAXUSERS) -> atomic{ inbox[(outSender+1) % MAXUSERS] ! outSender, (outConstraint-1), outContent; msgCount=msgCount+1; /*follower1*/ }
      :: else skip;
      fi;
S1:   if
      :: inSender != ((user+2) % MAXUSERS) -> atomic{ inbox[(outSender+2) % MAXUSERS] ! outSender, (outConstraint-1), outContent; msgCount=msgCount+1; /*follower2*/ }
      :: else skip;
	  fi
   :: atomic{outbox[ user ] ! outSender, outConstraint, outContent; msgCount=msgCount+1;}
   fi;
:: empty(inbox[user]) && empty(outbox[user]) && uniqueContent >= MSGLIMIT && msgCount == 0 -> break;
od
}

byte vi = 0;
byte vk = 0;	
init {
atomic{
	do
	:: (vi < MAXUSERS)  -> vi++;
	:: break;
	od;
    
	do
	:: (vk < MAXUSERS)  -> vk++;
	:: break;
	od;
    }
atomic{
	run userDevice(1);
	run userDevice(2);
	run userDevice(3);
	run userDevice(0);
	}
}

ltl fo { (
 (
 ([] (( (vi+1 > 1) && 
        (userDevice[vi+1]@S0) && 
		(userDevice[vi+1]:_3_outConstraint > 1 ) &&
		(userDevice[vi+1]:_3_outContent == vk)
 -> 
 ( <> ( (userDevice[((vi+1)%(MAXUSERS+1))]@R0) && 
        (userDevice[((vi+1)%(MAXUSERS+1))]:_3_inContent == vk) ))))) 
 )&&(
 ([] (( (vi > 1) && (userDevice[vi]@S1) && 
        (userDevice[vi+1]:_3_outConstraint > 1 ) &&
		(userDevice[vi+1]:_3_outContent == vk)
 -> 
 ( <> ( (userDevice[((vi+2)%(MAXUSERS+1))]@R0) && 
        (userDevice[((vi+2)%(MAXUSERS+1))]:_3_inContent == vk) )))))
 )
)
}
ltl fo2 { (
 ([] (((vi+1 > 0) && 
       userDevice[vi+1]@S0 &&
	   (userDevice[vi+1]:_3_outConstraint == 2 ) &&
	   (userDevice[vi+1]:_3_outContent == vk) &&
	   (((vi+1)%MAXUSERS) > 0) 
	  ) ->
	  (<> ((userDevice[(((vi+1)%MAXUSERS)+1%MAXUSERS)]@R0 &&
	        userDevice[(((vi+1)%MAXUSERS)+1%MAXUSERS)]:_3_inContent == vk) && 
	       (userDevice[(((vi+1)%MAXUSERS)+2%MAXUSERS)]@R0 &&
	        userDevice[(((vi+1)%MAXUSERS)+2%MAXUSERS)]:_3_inContent == vk))
	 )))
 &&
 ([] (((vi+1 > 0) && 
       userDevice[vi+1]@S0 &&
	   (userDevice[vi+1]:_3_outConstraint == 2 ) &&
	   (userDevice[vi+1]:_3_outContent == vk ) &&
	   (((vi+2)%MAXUSERS) > 0) 
	  ) ->
	  (<>((userDevice[(((vi+2)%MAXUSERS)+1%MAXUSERS)]@R0 &&
	       userDevice[(((vi+2)%MAXUSERS)+1%MAXUSERS)]:_3_inContent == vk) && 
	      (userDevice[(((vi+2)%MAXUSERS)+2%MAXUSERS)]@R0 &&
	       userDevice[(((vi+2)%MAXUSERS)+2%MAXUSERS)]:_3_inContent == vk))
	 )))
)}
