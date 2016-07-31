#define MAXUSERS    4

short uniqueId = 0;

typedef F_message
{
    short id;
    short sender;
}

chan recipients[MAXUSERS] = [4] of { F_message };

proctype receiveMsg( short receiver )
{
    F_message msg;
    do
    :: recipients[ receiver ] ? msg;
       assert (msg.sender <= MAXUSERS);
    od
}

proctype sendMsg ( short sender; short constraint )
{
    do
    :: 
        /*
        Build the message.
        */
        F_message msg;
        msg.id = uniqueId;
        uniqueId++;
        msg.sender = sender;
        
        /*
        Send the message to the corresponding followers.
        Implicitly it is possible to send to anyone, 
        but we only send to followers.
        */
        
        short fol1;
        short fol2;
        
        if
        :: (sender > 0) ->
            if
            :: (constraint == 0 || constraint == 1) ->
                
                /*Doing it for Fo*/
                    if
                    :: (sender > 0) -> 
                        recipients[((sender+1)%MAXUSERS)] ! msg;
                        recipients[((sender+2)%MAXUSERS)] ! msg;
                    :: else printf("sendMsgP: sender < 0 ");
                    fi
                
            :: constraint == 1 -> 
                
                /*Doing it for Fo2*/
                    fol1 = ((sender+1)%MAXUSERS);
                    fol2 = ((sender+2)%MAXUSERS);
                    if
                    :: (fol1 > 0) ->
                        recipients[((fol1+1)%MAXUSERS)] ! msg;
                        recipients[((fol1+2)%MAXUSERS)] ! msg;
                    :: else printf("sendMsgP: fol1 < 0");
                    fi;				
                    if
                    :: (fol2 > 0) ->
                        recipients[((fol2+1)%MAXUSERS)] ! msg;
                        recipients[((fol2+2)%MAXUSERS)] ! msg;
                    :: else printf("sendMsgP: fol2 < 0");
                    fi	

            fi
        :: else printf("sendMsg: sender < 0");
        fi
    od
	 
}


init
{
	run receiveMsg(1);
	run receiveMsg(2);
	run receiveMsg(3);	
	run receiveMsg(0);
	
	
	do
	:: run sendMsg(1,1); 
	:: run sendMsg(2,1); 
	:: run sendMsg(3,1); 
	:: run sendMsg(0,1);
	:: run sendMsg(1,0); 
	:: run sendMsg(2,0); 
	:: run sendMsg(3,0); 
	:: run sendMsg(0,0);
	od
}











