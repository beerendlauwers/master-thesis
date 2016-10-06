<%@ Page Language="VB" AutoEventWireup="false" CodeFile="ArtikelKiezen.aspx.vb" Inherits="App_Presentation_JS_ckeditor_ArtikelKiezen" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Artikel Kiezen</title>
</head>
<body>
    <form id="frmArtikelKiezen" runat="server">
    <asp:ScriptManager runat="server" ID="scmArtikelKiezen">
    </asp:ScriptManager>
    <asp:updatepanel runat="server" id="updArtikelKiezen"><ContentTemplate>
    <div>
    <table>
    <tr>
    <td>Versie</td>
    <td><asp:DropDownList ID="ddlVersie" runat="server" Width="400"></asp:DropDownList></td>
    </tr>
    <tr>
    <td>Taal</td>
    <td><asp:DropDownList ID="ddlTaal" runat="server" Width="400"></asp:DropDownList></td>
    </tr>
    <tr>
    <td>Bedrijf</td>
    <td><asp:DropDownList ID="ddlBedrijf" runat="server" Width="400"></asp:DropDownList></td>
    </tr>
    <tr>
    <td>&nbsp;</td>
    <td><asp:Button runat="server" ID="btnFilteren" Text="Filteren" Width="400" /></td>
    </tr>
    <tr>
    <td colspan="2">&nbsp;</td>
    </tr>
    <tr>
    <td colspan="2"><asp:DropDownList ID="ddlCategorien" runat="server" AutoPostBack="true" Width="450"></asp:DropDownList><asp:Label runat="server" ID="lblGeenCategorien" Visible="false" Text="Er zijn geen categorieën beschikbaar."></asp:Label></td>
    </tr>
    <tr>
    <td colspan="2"><asp:DropDownList ID="ddlArtikels" runat="server" Width="450"></asp:DropDownList><asp:Label runat="server" ID="lblGeenArtikels" Visible="false" Text="Er zijn geen artikels beschikbaar."></asp:Label></td>
    </tr>
    <tr>
    <td>&nbsp;</td>
    <td><input type="button" runat="server" id="btnArtikelSelecteren" value="Dit Artikel Selecteren" style="width:400px;" onclick="ArtikelOpslaan();" /></td>
    </tr>
    </table>
    
    <script type="text/javascript">
    <!--
    
    function ArtikelOpslaan()
    {
        var artikeldropdown = document.getElementById( '<%= ddlArtikels.ClientID %>');
        if( artikeldropdown )
        {
            var idx = artikeldropdown.selectedIndex;
            var waarde = artikeldropdown[idx].value;
            var text = artikeldropdown[idx].text;
            
            if( window.opener )
	        {
		        var toevoegeneditorinstantie = window.opener.CKEDITOR.instances.ctl00_ContentPlaceHolder1_EditorToevoegen;
		        var bewerkeneditorinstantie = window.opener.CKEDITOR.instances.ctl00_ContentPlaceHolder1_EditorBewerken;
		
		        if( toevoegeneditorinstantie || bewerkeneditorinstantie )
		        {
			        var intevullenwaardebox = window.opener.document.getElementById( 'ArtikelKiezenWaarde' );
			        var intevullentextbox = window.opener.document.getElementById( 'ArtikelKiezenTekst' );
			        if( intevullenwaardebox && intevullentextbox )
			        {
			        	intevullenwaardebox.value = waarde;
			        	intevullentextbox.value = text;
			        	self.close();
			        }
			        else
			        {
			        	alert('Kon de editor niet vinden.');
			        }
		        }
		    }
		    else
		    {
		    	alert('Kon de editor niet vinden.');
		    }
	    }
	    else
	    {
	    	alert('Kon de editor niet vinden.');
	    }
	}
    
    -->
    </script>
    
        <asp:UpdateProgress ID="prgArtikelKiezen" runat="server" AssociatedUpdatePanelID="updArtikelKiezen">
    <ProgressTemplate>
    <div class="update">
    <img src="../../CSS/Images/ajaxloader.gif" alt='' />
    Even wachten aub...
    </div>
    </ProgressTemplate>
    </asp:UpdateProgress>
    </div>
    </ContentTemplate></asp:updatepanel>
    </form>
</body>
</html>
