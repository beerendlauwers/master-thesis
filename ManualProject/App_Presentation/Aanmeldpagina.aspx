<%@ Page Language="VB" MasterPageFile="~/App_Presentation/MasterPage.master" AutoEventWireup="false" CodeFile="Aanmeldpagina.aspx.vb" Inherits="App_Presentation_Aanmeldpagina" title="Untitled Page" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<title>Aanmeldpagina</title>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolderTitel" Runat="Server">
Aanmeldpagina
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<br />
<div runat="server" id="divNietAangemeld">
    <asp:UpdatePanel ID="updInloggen" runat="server">
    <ContentTemplate>
Vul de juiste gebruikersnaam en wachtwoord in om Beheerder te worden.
<br />
<br />
<table>
<tr>
    <td><asp:Label ID="lblGebruikersnaam" runat="server" Text="Gebruikersnaam: "></asp:Label></td>

    <td><asp:TextBox ID="txtGebruikersNaam" runat="server"></asp:TextBox>
        <asp:RequiredFieldValidator ControlToValidate="txtGebruikersNaam" ID="vleGebruikersNaam" runat="server" DIsplay="None" ValidationGroup="valInloggen" ErrorMessage="Gelieve een gebruikersnaam in te geven."></asp:RequiredFieldValidator>
        <cc1:ValidatorCalloutExtender ID="extGebruikersNaam" TargetControlID="vleGebruikersNaam" runat="server">
        </cc1:ValidatorCalloutExtender>
    </td>
    </tr>
   <tr>
    <td><asp:Label ID="lblPaswd" runat="server" Text="Paswoord: "></asp:Label></td>
    
    <td><asp:TextBox ID="txtPaswd" runat="server" TextMode="Password"></asp:TextBox>
            <asp:RequiredFieldValidator ID="vlePaswd" ControlToValidate="txtPaswd" runat="server" DIsplay="None" ValidationGroup="valInloggen" ErrorMessage="Gelieve een paswoord in te geven."></asp:RequiredFieldValidator>
        <cc1:ValidatorCalloutExtender ID="extPaswd" TargetControlID="vlePaswd" runat="server">
        </cc1:ValidatorCalloutExtender></td></tr>
    <tr>
        <td><asp:Button ID="btnAanmelden" runat="server" Text="Aanmelden" ValidationGroup="valInloggen" Onclientclick="setZichtbaarheid()" /></td>
   <td>
       <asp:UpdateProgress ID="prgInloggen" runat="server">
    <ProgressTemplate>
    <div class="update">
    <img src="CSS/Images/ajaxloader.gif" />
    Bezig met aanmelden...
    </div>
    </ProgressTemplate>
    </asp:UpdateProgress>
       <div id="divRes" runat="server" style="display:inline">
       <asp:Image runat="server" ID="imgRes" ImageUrl="~/App_Presentation/CSS/images/spacer.gif" />&nbsp;
       <asp:Label ID="lblRes" runat="server" Text=" "></asp:Label>
       </div>
       <script type="text/javascript">
       <!--
       function setZichtbaarheid()
       {
        var elem = document.getElementById('<%=divRes.ClientID%>');
        if( elem )
        {
            elem.style.display = 'none';
        }
       }
       -->
       </script>
   </td>
    </tr>
</table>
</ContentTemplate>
    </asp:UpdatePanel>
</div>
<div runat="server" id="divWelAangemeld" visible="false">U bent reeds aangemeld.
<br />
<asp:Button ID="btnLogOut" runat="server" Text="Afmelden" /></div>
</asp:Content>
