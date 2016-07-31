#define MAXUSERS      4
#define MAXMESSAGES   2
#define MSGLIMIT	  1

/*
 * sender constraint content
 */
chan inbox[MAXUSERS] = [MAXMESSAGES] of { byte,byte,byte };
chan outbox[MAXUSERS] = [MAXMESSAGES] of { byte,byte,byte };

bit isActive[MAXUSERS];
bit uniqueContent = 0;

/*
 * userDevice reads from the inbox, (might forward -> outbox)
 * or sends from the outbox,
 * or creates a new mesage and adds to the outbox,
 * or skip.
 */
proctype userDevice (byte user){
byte inSender;
byte inConstraint;
byte inContent;
byte outSender;
byte outConstraint;
byte outContent;

do
/* READ AN INBOX MESSAGE */
:: nempty( inbox[ user ] ) ->
   atomic{
   inbox[ user ] ? inSender, inConstraint, inContent;
   d_step{
   isActive[(user)] = 1;   
   isActive[(user+1)%MAXUSERS] = 1;   
   isActive[(user+2)%MAXUSERS] = 1;
   }
   }
R0: skip;
   atomic{
   if
   :: inConstraint > 1 && user > 0 && 
      (inSender != ((user+1) % MAXUSERS) && 
	   inSender != ((user+2) % MAXUSERS)) ->
	   if
	   :: nfull(outbox[user]) -> outbox[user] ! inSender, inConstraint, inContent;
	   :: full(outbox[user]) -> inbox [ user ] ! inSender, inConstraint, inContent;
	   fi
   :: else -> skip; /*dont send, its constraint is 0*/
   fi;
   }
   /*acknowledge to sender */
   
/*CREATE A NEW MESSAGE TO OUTBOX */
:: empty(inbox[user]) && empty(outbox[user]) && uniqueContent < MSGLIMIT && user > 0 -> atomic{ 
   if
   :: outbox[ user ] ! user, 1, uniqueContent; /*outbox is not full, so this will not block.*/
   uniqueContent = uniqueContent + 1;
   :: outbox[ user ] ! user, 2, uniqueContent; /*outbox is not full, so this will not block.*/
   uniqueContent = uniqueContent + 1;
   fi;
   }
/*SEND AN OUTBOX MESSAGE*/
:: nempty(outbox[user]) ->
   atomic{
   outbox[ user ] ? outSender, outConstraint, outContent;  
   d_step{   
   isActive[(user)] = 1;   
   isActive[(user+1)%MAXUSERS] = 1;   
   isActive[(user+2)%MAXUSERS] = 1;
   }
   }
   if
   :: (nfull(inbox[(user+1) % MAXUSERS]) && 
       nfull(inbox[(user+2) % MAXUSERS])) -> 
	inbox[(user+1) % MAXUSERS] ! outSender, (outConstraint-1), outContent; /*follower1*/
S0: skip;
    inbox[(user+2) % MAXUSERS] ! outSender, (outConstraint-1), outContent; /*follower2*/
S1: skip;
   ::  (full(inbox[(user+1) % MAXUSERS]) || 
       full(inbox[(user+2) % MAXUSERS]))  -> outbox[ user ] ! outSender, outConstraint, outContent;
   fi;
:: uniqueContent >= MSGLIMIT && empty(inbox[user]) && empty(outbox[user]) && isActive[user] == 1 -> isActive[user] = 0;
:: uniqueContent >= MSGLIMIT && isActive[user] == 0 && (isActive[0] == 1 || isActive[1] == 1 || isActive[2] == 1 || isActive[3] == 1) -> skip;
:: uniqueContent >= MSGLIMIT && isActive[0] == 0 && isActive[1] == 0 && isActive[2] == 0 && isActive[3] == 0 -> break;
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
 ([] (((vi > 0) && 
       userDevice[vi+1]@S0 &&
	   (userDevice[vi+1]:_3_outConstraint == 2 ) &&
	   (userDevice[vi+1]:_3_outContent == 2 ) &&
	   (((vi+2)%MAXUSERS) > 0) 
	  ) ->
	  (<>((userDevice[(((vi+2)%MAXUSERS)+1%MAXUSERS)]@R0 &&
	       userDevice[(((vi+2)%MAXUSERS)+1%MAXUSERS)]:_3_inContent == vk) && 
	      (userDevice[(((vi+2)%MAXUSERS)+2%MAXUSERS)]@R0 &&
	       userDevice[(((vi+2)%MAXUSERS)+2%MAXUSERS)]:_3_inContent == vk))
	 )))
)}
