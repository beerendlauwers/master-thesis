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

function ShadowBoxLaderTonen()
{
    // open a message
    Shadowbox.open({
        content:    '<div style="padding-top:40px;text-align:center;vertical-align:middle;color:#FFFFFF;font-family:arial,verdana;"><img src="CSS/images/loading.gif" style="vertical-align:middle;"/> ' + wachtenlaadtekst + '</div>',
        player:     "html",
        height: 100,
        width: 200
    });
}

function ShadowBoxLaderSluiten()
{
    // close message
    parent.Shadowbox.close();
}


function ShadowBoxTonen( message )
{
    // open a message
    Shadowbox.open({
        content:    '<div style="color:white;padding: 4px 4px 4px 4px;">' + message + '</div>',
        player:     "html"
    });
}

function WaardeSubmitten(source, tekstWaarde, validatieGroep, metPostback)
{
	ret = true;
	
    if (typeof (Page_ClientValidate) == 'function')
    {
        if( validatieGroep != null )
        {
            if(typeof (validatieGroep) == 'boolean') 
            {
                if( validatieGroep == false )
                {
                    ret = true;
                    alert('geen validatie');
                }
            }
            else
            {
                Page_ClientValidate( validatieGroep );
                ret = Page_IsValid;
                alert('enkel validatiegroep ' + validatieGroep + ' valideren');
            }
        }
        else
        {
            Page_ClientValidate();
            ret = Page_IsValid;
            alert('alles valideren');
        }
    }
    
    alert(ret);
    
    if (ret)
    {
        source.value = tekstWaarde;
        source.disabled = true;
        
        if( metPostback )
        {
            __doPostBack(source.name, "");
            alert('postback gedaan');
        }
    }
    return ret;
}