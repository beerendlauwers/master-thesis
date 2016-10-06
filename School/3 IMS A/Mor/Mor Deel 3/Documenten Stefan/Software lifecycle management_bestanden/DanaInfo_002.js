var longFmtWindow = 0;
var bbagWindow = 0;
var helpWindow = 0;
var winavailwidth = screen.availWidth;
var winX = ( winavailwidth - 475 ); 
var ns4 = (document.layers)? true:false
var ie4 = (document.all)? true:false
var winparams = "";

function MM_goToURL() { //v3.0
  var i, args=MM_goToURL.arguments; document.MM_returnValue = false;
  //  alert('linking away ....');
  for (i=0; i<(DanaGetLength(args)-1); i+=2) eval(DanaEval(args[i]+".location='"+args[i+1]+"'"));
}


function popupBBagWindow( URLstr, focusFlag )
{
  if (ie4)
  {
     winparams = 'scrollbars=yes,location=yes,resizable=yes,width=450,height=400,left='+winX;

  }
  else
  {
	 winparams = 'scrollbars=yes,location=yes,resizable=yes,width=450,height=400,screenX='+winX;

  }


    if ( bbagWindow && !bbagWindow.closed )
    {
        if ( focusFlag )
        {  bbagWindow.focus();   }
    }
    else
    {
	bbagWindow = DanaMethodOpen("open",window, '', "bibbookbag", winparams );
        if ( focusFlag )
        {      bbagWindow.focus( );      }
        else
        {       self.focus();    }
    }

    DanaMethodWrite("write",bbagWindow.document,'<p>Retrieving bookbag, please wait ...</p>');
    DanaPutLocation(bbagWindow.document , URLstr,0);
}


function popupLongFmtWindow( URLstr )
{
  if (ie4)
  {
          winparams = 'scrollbars=yes,location=yes,resizable=yes,width=450,height=600,left='+winX;
  }
  else
  {
          winparams = 'scrollbars=yes,location=yes,resizable=yes,width=450,height=600,screenX='+winX;
  }


  if ( longFmtWindow && !longFmtWindow.closed )
  {
          longFmtWindow.focus();
  }
  else
  {
          longFmtWindow = DanaMethodOpen("open",window, '', "longformat", winparams );
          longFmtWindow.focus( );
  }

  DanaMethodWrite("write",longFmtWindow.document,'<p>Retrieving record in long format, please wait ...</p>');
  DanaPutLocation(longFmtWindow.document , URLstr,0);
}



function popupHelpWindow( URLstr, focusFlag )
{
  if (ie4)
  {
     winparams = 'scrollbars=yes,resizable=yes,width=600,height=500';

  }
  else
  {
	 winparams = 'scrollbars=yes,resizable=yes,width=600,height=500';

  }


    if ( helpWindow && !helpWindow.closed )
    {
        if ( focusFlag )
        {  helpWindow.focus();   }
    }
    else
    {
	helpWindow = DanaMethodOpen("open",window, '', "bookbag", winparams );
        if ( focusFlag )
        {      helpWindow.focus( );      }
        else
        {       self.focus();    }
    }

    DanaPutLocation(helpWindow.document , URLstr,0);
}



function MM_openBrWindow(theURL,winName,features) { //v2.0
DanaMethodOpen("open",window,theURL,winName,features);
}
 
