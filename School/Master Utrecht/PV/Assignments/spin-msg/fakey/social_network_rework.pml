#define MAXUSERS      4
#define MAXMESSAGES   0

typedef F_message
{
  byte sender;
  bit constraint;
}

chan recipients[MAXUSERS] = [MAXMESSAGES] of { F_message };

proctype receiveMsg( byte receiver )
{
	F_message recMsg;
    do
    :: recipients[ receiver ] ? recMsg;
	   byte fol1,fol2;
	   fol1 = (recMsg.sender+1)%MAXUSERS;
	   fol2 = (recMsg.sender+2)%MAXUSERS;
       assert ((fol1 == receiver) || (fol2 == receiver)
           || ((fol1+2)%MAXUSERS == receiver) || ((fol1+2)%MAXUSERS == receiver)
           || ((fol2+2)%MAXUSERS == receiver) || ((fol2+2)%MAXUSERS == receiver)
		   );
    od;
}

proctype sendMsg (byte sender; bit constraint){
	
	F_message newMsg;
	byte fol1, fol2, fol11, fol12, fol21, fol22;
	
	d_step{
	newMsg.sender = sender;
	newMsg.constraint = constraint;	
	
	fol1 = ((sender+1)%MAXUSERS);
	fol2 = ((sender+2)%MAXUSERS);
	fol11 = ((fol1+1)%MAXUSERS);
	fol12 = ((fol1+2)%MAXUSERS);
	fol21 = ((fol2+1)%MAXUSERS);
	fol22 = ((fol2+2)%MAXUSERS);	
	}
	
	
	do
	::  if
		:: (sender > 0) -> atomic{ /*Send to Fo*/
		   if 
		   :: fol1 != sender -> recipients[fol1] ! newMsg
		   :: else skip
		   fi;
		   if
		   :: fol2 != sender -> recipients[fol2] ! newMsg	
		   :: else skip
		   fi;
		   }
		   if
		   :: (constraint == 1) -> atomic{ /*Send to Fo2*/
			  if
			  :: sender != fol11 -> recipients[fol11] ! newMsg
			  :: else skip
			  fi;
			  if
			  :: sender != fol12 -> recipients[fol12] ! newMsg
			  :: else skip
			  fi;
			  if
			  :: sender != fol21 -> recipients[fol21] ! newMsg
			  :: else skip
			  fi;
			  if
			  :: sender != fol22 -> recipients[fol22] ! newMsg
			  :: else skip
			  fi
			  }
		   :: else skip
		   fi
		:: else skip
		fi
	od;
	
	
}

init
{
	/*
	 * Start all receivers and senders, for every channel (maxusers) 
	 */

	byte i = 0;
	
	atomic{
	do
	:: (i < MAXUSERS) -> run receiveMsg(i); run sendMsg (i,0); run sendMsg (i,1); i++;
	:: else -> break;
	od;
	}
}
