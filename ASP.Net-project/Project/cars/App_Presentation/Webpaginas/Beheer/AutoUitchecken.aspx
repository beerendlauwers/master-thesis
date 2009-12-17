<%@ Page Language="VB" MasterPageFile="~/App_Presentation/MasterPage.master" AutoEventWireup="false" CodeFile="AutoUitchecken.aspx.vb" Inherits="App_Presentation_Webpaginas_Beheer_AutoUitchecken" title="Untitled Page" %>
  <%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="plcMain" Runat="Server">

<h1>Auto Uitchecken</h1>

<asp:UpdatePanel runat="server" ID="updAutoUitchecken">
<ContentTemplate>

<table>
<tr>
<td colspan="2">Selecteer klant op:</td>
</tr>
<tr>
<td>Naam en voornaam</td>
<td>
<asp:TextBox ID="txtNaam" runat="server"></asp:TextBox>
<cc1:AutoCompleteExtender ID="txtNaam_AutoCompleteExtender" runat="server" 
        DelimiterCharacters="" Enabled="True" ServicePath="../../WebServices/AutoCompleteNaam.asmx" ServiceMethod="GetCompletionList" TargetControlID="txtNaam" MinimumPrefixLength="3" CompletionSetCount="12">
    </cc1:AutoCompleteExtender>
 
 
 
<asp:TextBox ID="txtVoornaam" runat="server"></asp:TextBox>
<cc1:AutoCompleteExtender ID="txtVoornaam_AutoCompleteExtender" runat="server" 
        DelimiterCharacters="" Enabled="True" ServicePath="../../WebServices/AutoCompleteVoorNaam.asmx" ServiceMethod="GetCompletionList" TargetControlID="txtVoornaam" MinimumPrefixLength="3" CompletionSetCount="12">
    </cc1:AutoCompleteExtender>

</td>
</tr>
<tr>
<td>Rijbewijsnummer</td>
<td><asp:TextBox ID="txtRijbewijs" runat="server"></asp:TextBox> </td>
</tr>
<tr>
<td>Identiteitskaartnummer</td>
<td><asp:TextBox ID="txtIdenteitskaart" runat="server"></asp:TextBox> </td>
</tr>
<tr>
    <td align="center"><asp:Button ID="btnZoekKlant" runat="server" Text="Zoek Klant" />
    </td>
    <td>
                                                        <asp:UpdateProgress ID="progress1" runat="server">
        <ProgressTemplate>
        
            <div class="progress">
                <img src="../../Images/ajax-loader.gif" />
                Even wachten aub...
            </div>
        
        </ProgressTemplate>
    </asp:UpdateProgress>
    <asp:Label runat="server" ID="lblError"></asp:Label></td>
</tr>
</table>

<div runat="server" id="divRepeater" visible="false">
    <h3>Klantgegevens</h3>
    <asp:Repeater ID="repKlant" runat="server">
    <HeaderTemplate>
    <table>
        <tr>
            <th>
                Naam
            </th>
            <th>
                Voornaam
            </th>
            <th>
                Geboortedatum
            </th>
            <th>
                Identiteitskaartnr.
            </th>
            <th>
                Rijbewijsnr.
            </th>
            <th>
                Heeft recht op korting
            </th>
            <th>
                Is problematisch?
            </th>
        </tr>
    </HeaderTemplate>
    <ItemTemplate>
            <tr>
            <td>
                <%#DataBinder.Eval(Container.DataItem, "userVoornaam")%>
            </td>
            <td>
                <%#DataBinder.Eval(Container.DataItem, "userNaam")%>
            </td>
            <td>
                <%#(CType(Container.DataItem, System.Data.DataRowView)("userGeboortedatum")).ToShortDateString()%> 
            </td>
            <td>
                <%#DataBinder.Eval(Container.DataItem, "userIdentiteitskaartnr")%>
            </td>
            <td>
                <%#DataBinder.Eval(Container.DataItem, "userRijbewijsnr")%>
            </td>
            <td>
                <%#DataBinder.Eval(Container.DataItem, "userHeeftRechtOpKorting")%>
            </td>
            <td>
                <%#DataBinder.Eval(Container.DataItem, "userIsProblematisch")%>
            </td>
        </tr>
        </table>
        
        Commentaar: <%#DataBinder.Eval(Container.DataItem, "userCommentaar")%>
    </ItemTemplate>
    </asp:Repeater>
    
    <div runat="server" id="divChauffeurs" visible="false">
    <h3>Chauffeurgegevens</h3>
    
    Deze klant is een bedrijfsverantwoordelijke, en heeft de volgende chauffeurs:
    
    <table>
        <tr>
            <th>
                Naam Chauffeur
            </th>
            <th>
                Voornaam Chauffeur
            </th>
            <th>
                Rijbewijs Chauffeur
            </th>
        </tr>
            <asp:Repeater ID="repChauffeurs" runat="server">
    <ItemTemplate>
            <tr>
            <td>
                <%#DataBinder.Eval(Container.DataItem, "chauffeurNaam")%>
            </td>
            <td>
                <%#DataBinder.Eval(Container.DataItem, "chauffeurVoornaam")%>
            </td>
            <td>
                <%#DataBinder.Eval(Container.DataItem, "chauffeurRijbewijs")%>
            </td>
        </tr>
</ItemTemplate>
    </asp:Repeater>
            </table>
    </div>

<h3>Reservatiegegevens</h3>

<table>
<tr>
<td>
   Reservaties bezien voor filiaal <asp:DropDownList ID="ddlFiliaal" runat="server" AutoPostBack="true"></asp:DropDownList>
    <br />
        Maand: <asp:Label ID="lblReservatieOverzichtMaand" runat="server" ></asp:Label><br />
    <asp:Button ID="btnMaandVroeger" runat="server" Text="Maand Vroeger" />&nbsp;<asp:Button ID="btnMaandLater" runat="server" Text="Maand Later" />
    <br />

    <br />

    <asp:Label ID="lblGeenReservaties" runat="server" Visible="false"></asp:Label>
</td>
<td>
<asp:UpdateProgress ID="UpdateProgress1" runat="server">
        <ProgressTemplate>
        
            <div class="progress">
                <img src="../../Images/ajax-loader.gif" />
                Even wachten aub...
            </div>
                    </ProgressTemplate>
    </asp:UpdateProgress>
</td>
</tr>
</table>
<br />
   
   <div runat="server" id="divReservatieOverzicht">     
<table>
        <tr>
            <th>
                Kenteken
            </th>
            <th>
                Merk En Model
            </th>
            <th>
                Parkeerplaats
            </th>
            <th>
                Begindatum
            </th>
            <th>
                Einddatum
            </th>
            <th>
                &nbsp;
            </th>
        </tr>
            <asp:Repeater ID="repReservatieOverzicht" runat="server">
    <ItemTemplate>
            <tr>
            <td>
                <%#DataBinder.Eval(Container.DataItem, "Kenteken")%>
            </td>
            <td>
                <%#DataBinder.Eval(Container.DataItem, "MerkModel")%>
            </td>
            <td>
                <%#DataBinder.Eval(Container.DataItem, "Parkeerplaats")%>
            </td>
            <td>
            <%#(CType(Container.DataItem, System.Data.DataRowView)("Begindatum")).ToShortDateString()%> 
            </td>
            <td>
            <%#(CType(Container.DataItem, System.Data.DataRowView)("Einddatum")).ToShortDateString()%> 
            </td>
            <td>
                <asp:LinkButton ID="lnkAutoUitchecken" runat="server" CommandArgument='<%#DataBinder.Eval(Container.DataItem, "Data")%>'>Deze auto uitchecken</asp:LinkButton>
            </td>
        </tr>
        
</ItemTemplate>
    </asp:Repeater>
            </table>
            
            </div>
            
            
  
</div>

    <div style="text-align: center;">
        <br />
        <asp:Image ID="imgResultaat" runat="server" Visible="false" />&nbsp;<asp:Label ID="lblResultaat"
            runat="server" Visible="false"></asp:Label>
    </div>

</ContentTemplate>
</asp:UpdatePanel>

</asp:Content>

