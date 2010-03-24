function veranderDropdown(imagenaam)
{
	var image = document.getElementById(imagenaam).src;
	var pos = image.indexOf("/images/");
	
	var beginpart = image.substring( 0, pos );
	
	if( pos >= 0 )
	{
		image = image.substring( pos, image.length );
	}
	
	if(image=='/images/add.png')
	{
		document.getElementById(imagenaam).src= beginpart + '/images/minus.png'
	}
	
	if(image=='/images/minus.png')
	{
		document.getElementById(imagenaam).src= beginpart + '/images/add.png'
	}
}

function VeranderEditorScherm( aantal )
{
   var elem = document.getElementById('ctl00_ContentPlaceHolder1_Editor1');
   
   if ( elem )
   {
      if ( elem.style.height == "100%" )
    {
        elem.style.height = "800px";
    }
    else
    {
        var height = elem.style.height;
        height = height.substring( 0, height.length - 2 );
        height = parseInt(height) + aantal;
        elem.style.height = height + "px";
    }
   }
}