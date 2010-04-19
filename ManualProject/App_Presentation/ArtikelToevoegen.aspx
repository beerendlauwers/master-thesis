<%@ Page Language="VB" MasterPageFile="~/App_Presentation/MasterPage.master" AutoEventWireup="false" ValidateRequest="false" CodeFile="ArtikelToevoegen.aspx.vb" Inherits="App_Presentation_invoerenTest" title="Untitled Page" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc2" %>
<%@ Register Assembly="FredCK.CKEditor" Namespace="FredCK.CKEditor" TagPrefix="FredCK" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <title>Artikel toevoegen</title>
    <link href="CSS/prototip.css" rel="stylesheet" type="text/css" />
    <script src="JS/prototype.js" language="javascript" type="text/javascript"></script>
    <script src="js/prototip.js" language="javascript" type='text/javascript' ></script>
    <script src="JS/ckeditor/ckeditor.js" language="javascript" type="text/javascript"></script>
    <script src="JS/ckfinder/ckfinder.js" language="javascript" type="text/javascript"></script>
       
    </asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolderTitel" runat="server">Artikel Toevoegen</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div runat="server" id="divLoggedIn">
    
<div id="divInvullen">

<asp:UpdatePanel ID="updCategorie" runat="server">
<ContentTemplate>

<table>

<tr>
<td class="lbl"><asp:Label ID="lbltitel" runat="server" Text="Titel:"></asp:Label></td>
<td><asp:TextBox ID="txtTitel" runat="server" Width="100%"></asp:TextBox>
    <asp:RequiredFieldValidator
        ID="vleTitel" runat="server" ErrorMessage="Gelieve een titel in te geven." 
        ControlToValidate="txtTitel" Display="None"></asp:RequiredFieldValidator>
    <cc2:ValidatorCalloutExtender
            ID="extTitel" runat="server" TargetControlID="vleTitel">
        </cc2:ValidatorCalloutExtender>
</td>
<td>
<span style="vertical-align:middle" id='tipTitelArtikelToevoegen'><img src="CSS/images/help.png" alt=''/></span>
</td>
</tr>

<tr>
<td class="lbl"><asp:Label ID="lblTag" runat="server" Text="Tag:"></asp:Label></td>
<td><asp:TextBox ID="txtTag" runat="server" Width="100%"></asp:TextBox><asp:RequiredFieldValidator
        ID="vleTag" runat="server" Display="None" 
        ErrorMessage="Gelieve een tag in te geven. Deze mag enkel letters, nummers en een underscore ( _ ) bevatten." 
        ControlToValidate="txtTag"></asp:RequiredFieldValidator>
    <cc2:ValidatorCalloutExtender
            ID="extTag" runat="server" TargetControlID="vleTag">
        </cc2:ValidatorCalloutExtender>
    <cc2:FilteredTextBoxExtender ID="fltTag" runat="server" 
        FilterType="Custom, Numbers, UppercaseLetters, LowercaseLetters" TargetControlID="txtTag" 
        ValidChars="_"></cc2:FilteredTextBoxExtender>
	    </td>
	    <td>
	    <span style="vertical-align:middle" id='tipTagArtikelToevoegen'><img src="CSS/images/help.png" alt=''/></span>
	    </td>
</tr>

<tr>
<td class="lbl"><asp:Label ID="lblTaal" runat="server" Text="Taal:"></asp:Label></td>
<td><asp:DropDownList ID="ddlTaal" runat="server" 
        DataTextField="Taal" DataValueField="TaalID" AutoPostBack="true" Width="100%">
    </asp:DropDownList>
</td>
<td>
<span style="vertical-align:middle" id='tipTaalArtikelToevoegen'><img src="CSS/images/help.png" alt=''/></span>
</td>
</tr>

<tr>
<td class="lbl"><asp:Label ID="lblBedrijf" runat="server" Text="Bedrijf: "></asp:Label></td>
<td><asp:DropDownList ID="ddlBedrijf" runat="server"  
        DataTextField="Naam" DataValueField="BedrijfID" AutoPostBack="true" Width="100%">
    </asp:DropDownList>
</td>
<td>
<span style="vertical-align:middle" id='tipBedrijfArtikelToevoegen'><img src="CSS/images/help.png" alt=''/></span>
</td>
</tr>

<tr>
<td class="lbl"><asp:Label ID="lblVersie" runat="server" Text="Versie:"></asp:Label></td>
<td><asp:DropDownList ID="ddlVersie" runat="server"  
    DataTextField="Versie" DataValueField="VersieID" AutoPostBack="true" Width="100%">
    </asp:DropDownList>
</td>
<td>
<span style="vertical-align:middle" id='tipVersieArtikelToevoegen'><img src="CSS/images/help.png" alt=''/></span>
</td>
</tr>

<tr>
<td class="lbl"><asp:Label ID="lblCategorie" runat="server" Text="Categorie:"></asp:Label></td>
<td><asp:DropDownList ID="ddlCategorie" runat="server" 
        DataTextField="Categorie" DataValueField="CategorieID" Width="100%">
</asp:DropDownList>
<asp:Label runat="server" ID="lblGeenCategorie" Visible="false" Text="Er zijn geen categorieën beschikbaar."></asp:Label>
</td>
<td>
<span style="vertical-align:middle" id='tipCategorieArtikelToevoegen'><img src="CSS/images/help.png" alt=''/></span>
</td>
<td>
    <asp:UpdateProgress ID="prgCategorie" runat="server" AssociatedUpdatePanelID="updCategorie">
    <ProgressTemplate>
    <div class="update">
    <img src="CSS/Images/ajaxloader.gif" />
    Bezig met ophalen van categoriëen...
    </div>
    </ProgressTemplate>
    </asp:UpdateProgress>
</td>
</tr>

<tr>
<td class="lbl"><asp:Label ID="lblFinaal" runat="server" Text="Finale versie:"></asp:Label></td>
<td><asp:CheckBox ID="ckbFinaal" runat="server" />
<span style="vertical-align:middle" id='tipFinaalArtikelToevoegen'><img src="CSS/images/help.png" alt=''/></span>
</td>
</tr>

</table>

</ContentTemplate>
</asp:UpdatePanel>

</div>

<asp:UpdatePanel ID="updContent" runat="server" UpdateMode="Conditional">
<ContentTemplate>
<table>
<tr>
<td align="center">Sjabloon selecteren&nbsp;<span style="vertical-align:middle" id='tipSjabloonArtikelToevoegen'><img src="CSS/images/help.png" alt=''/></span></td>
</tr>
<tr>
<td align="center"><asp:ListBox runat="server" ID="lstSjablonen" width="100%"></asp:ListBox></td>
</tr>
<tr>
<td align="center"><asp:Button runat="server" ID="btnSjablonen" Text="Sjabloon Toevoegen" width="100%" CausesValidation="false" style="vertical-align:middle;" /></td>
</tr>
</table>
<br />
    <FredCK:CKEditor runat="server" ID="EditorToevoegen" Height="600"></FredCK:CKEditor>
    <script type="text/javascript">
    CKFinder.SetupCKEditor( null, 'JS/ckfinder/' );
    </script>
			



</ContentTemplate>
</asp:UpdatePanel>
<br />
<br />
<div style="text-align:center;">
    <asp:UpdatePanel ID="updToevoegen" runat="server">
    <ContentTemplate>
<asp:Button ID="btnVoegtoe" runat="server" UseSubmitBehavior="true" Text="Artikel Toevoegen" />
    <asp:UpdateProgress ID="prgToevoegen" runat="server" AssociatedUpdatePanelID="updToevoegen">
    <ProgressTemplate>
    <div class="update">
    <img src="CSS/Images/ajaxloader.gif" />
    Bezig met opslaan...
    </div>
    </ProgressTemplate>
    </asp:UpdateProgress>
    <div runat="server" id="divFeedback" visible="false">
        <asp:Image ID="imgResultaat" runat="server" ImageUrl="~/App_Presentation/CSS/images/spacer.gif" />&nbsp;<asp:Label ID="lblresultaat" runat="server"></asp:Label><br />
    </div>
    <div runat="server" id="divNogEenArtikelToevoegen" visible="false">
    <input id="btnNieuwArtikel" type="button" value="Nog een artikel toevoegen" onclick="window.location = 'ArtikelToevoegen.aspx'" />
    </div>
</ContentTemplate>
    </asp:UpdatePanel>
</div>

    <br />
    </div>
    </asp:Content>

