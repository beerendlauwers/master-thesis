#define MAXUSERS    6

/* Beerend Lauwers, Frank Wijmans
 * Networking algorithm - March, 2012
 */

short uniqueId = 0;

typedef F_message
{
    short id;
    byte sender;
}

/*
 *
 */

chan recipients[MAXUSERS] = [4] of { F_message };

proctype receiveMsg( show byte receiver )
{
    F_message msg;
    do
    :: recipients[ receiver ] ? msg;
       assert (msg.sender <= MAXUSERS);
	   assert (((msg.sender+1)%MAXUSERS == receiver) ||
			   ((msg.sender+2)%MAXUSERS == receiver)
	   );
    od
}

proctype sendMsg ( byte sender; byte constraint )
{
	do
	::
		/*
		 * Build the message.
		 */
		F_message msg;
        d_step{
		msg.id = uniqueId;
		uniqueId++;
		msg.sender = sender;
        }
		
		/*
		 * Send the message to the corresponding followers.
		 * Implicitly it is possible to send to anyone, 
		 * but we only send to followers.
		 */
		
        byte fol1, fol2, fol11, fol12, fol21, fol22;
        d_step{
		fol1 = ((sender+1)%MAXUSERS);
		fol2 = ((sender+2)%MAXUSERS);
		fol11 = ((fol1+1)%MAXUSERS);
		fol12 = ((fol1+2)%MAXUSERS);
		fol21 = ((fol2+1)%MAXUSERS);
		fol22 = ((fol2+2)%MAXUSERS);
        }
		
		if
		:: (sender > 0) ->
			if
			:: (constraint == 0 || constraint == 1) ->
				
				/*
				 * Doing it for Fo
				 * Only send to the follow if the sender is not 0, he has no followers.
				 * Otherwise take the followers of the ender, check if they are not the same, 
				 * because you don't want to send it to yourself.
				 * Add the msg to channel of the follower.
				 * This is equal for the Fo2 constraint.
				 */
					if
					:: (sender > 0) -> 
						atomic {
						if 
						:: (sender != fol1) -> recipients[fol1] ! msg;
						:: else skip;
						fi;
						if 
						:: (sender != fol2) -> recipients[fol2] ! msg;
						:: else skip;
						fi
						}
					:: else printf("sendMsgP: sender < 0 ");
					fi
				
			:: constraint == 1 -> 
				
				/*
				 * Doing it for Fo2
				 */
					if
					:: (fol1 > 0) ->
						atomic {
						if 
						:: (sender != fol11 && fol1 != fol11) -> recipients[fol11] ! msg;
						:: else skip;
						fi;
						if 
						:: (sender != fol12 && fol1 != fol12) -> recipients[fol12] ! msg;
						:: else skip;
						fi
						}
					:: else printf("sendMsgP: fol1 < 0");
					fi;				
					if
					:: (fol2 > 0) ->
						atomic {
						if 
						:: (sender != fol21 && fol2 != fol21) -> recipients[fol21] ! msg;
						:: else skip;
						fi;
						if 
						:: (sender != fol22 && fol2 != fol22) -> recipients[fol22] ! msg;
						:: else skip;
						fi
						}
					:: else printf("sendMsgP: fol2 < 0");
					fi	

			fi
		:: else printf("sendMsg: sender < 0");
		fi
	od 
}


init
{
	/*
	 * Start all receivers and senders, for every channel (maxusers) once, and for every constraint. (2)
	 */
	byte iterator = 0;
	byte constraint = 0;

	RM: 
		printf("Starting a receiver for %d\n", iterator);
		if 
		:: (iterator < MAXUSERS) ->	
			run receiveMsg(iterator);	
			iterator++; 
			goto RM
		:: else 
			iterator = 0; 
			goto SM
		 fi;
	
	SM: 
		printf("Starting a receiver for %d\n", iterator);
		if 
		:: (iterator < MAXUSERS) ->	
			run sendMsg(iterator, constraint);	
			iterator++; 
			goto SM
		:: else
			iterator = 0; 
			if
			:: constraint == 0 -> constraint = 1; goto SM
			:: constraint == 1 -> goto done
			fi
		 fi;
	done: 
		skip
}