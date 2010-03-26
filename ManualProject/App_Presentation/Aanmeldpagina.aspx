<%@ Page Language="VB" MasterPageFile="~/App_Presentation/MasterPage.master" AutoEventWireup="false" CodeFile="Aanmeldpagina.aspx.vb" Inherits="App_Presentation_Aanmeldpagina" title="Untitled Page" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolderTitel" Runat="Server">
Log hier in voor beheerdersrechten.
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<br />
Vul de juiste gebruikersnaam en wachtwoord in om Beheerder te worden.
<br />
<br />
<table>
<tr>
    <td><asp:Label ID="lblGeberuikersnaam" runat="server" Text="GebruikersNaam: "></asp:Label></td>

    <td><asp:TextBox ID="txtGebruikersNaam" runat="server"></asp:TextBox></td>
    </tr>
   <tr>
    <td><asp:Label ID="lblPaswd" runat="server" Text="Paswoord: "></asp:Label></td>
    
    <td><asp:TextBox ID="txtPaswd" runat="server" TextMode="Password"></asp:TextBox></td></tr>
    <tr>
        <td><asp:Button ID="btnAanmelden" runat="server" Text="Aanmelden" /></td>
   <td>
       <asp:Label ID="lblRes" runat="server" Text=""></asp:Label>
   </td>
    </tr>
</table>
</asp:Content>
