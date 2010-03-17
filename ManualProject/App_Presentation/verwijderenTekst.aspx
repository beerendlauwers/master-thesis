<%@ Page Language="VB" MasterPageFile="~/App_Presentation/MasterPage.master" AutoEventWireup="false" CodeFile="verwijderenTekst.aspx.vb" Inherits="App_Presentation_verwijderenTekst" title="Untitled Page" %>

<%@ Register assembly="AjaxControlToolkit" namespace="AjaxControlToolkit" tagprefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<title>Artikel Verwijderen</title>
</asp:Content>
<asp:Content runat="server" ID="Content3" ContentPlaceHolderID="ContentPlaceHolderTitel">Artikel Verwijderen</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    <asp:UpdatePanel ID="updVerwijderen" runat="server">
    <ContentTemplate>
<table>
    
<tr>
<th colspan="2">Zoek een artikel op basis van de titel:</th>
</tr>

<tr>
<td><asp:Label ID="lblZoekTitel" runat="server" Text="Titel:"></asp:Label></td>
<td><asp:TextBox ID="txtSearchTitel" runat="server"></asp:TextBox>
    <asp:Label ID="lblSearchTitelResultaat" runat="server" visible="false"></asp:Label></td>
</tr>

<tr>
<th colspan="2">Zoek een artikel op basis van een stuk tekst:</th>
</tr>

<tr>
<td><asp:Label ID="lblZoekTekst" runat="server" Text="Tekst:"></asp:Label></td>
<td><asp:TextBox ID="txtSearchText" runat="server"></asp:TextBox>
    <asp:Label ID="lblSearchTextResultaat" runat="server" visible="false"></asp:Label></td>
</tr>

<tr>
<th colspan="2">&nbsp;</th>
</tr>

<tr>
<td colspan="2"><asp:Button ID="btnZoek" runat="server" Text="Zoeken" Width="100%" /></td>
</tr>

</table>

<div id="gridview">

    <asp:GridView ID="grdResultaten" runat="server" 
        AutoGenerateColumns="False" Visible="false">
        <Columns>
            <asp:BoundField DataField="Titel" HeaderText="Titel" SortExpression="Titel" />
            <asp:BoundField DataField="Tag" HeaderText="Tag" SortExpression="Tag" />
            <asp:BoundField DataField="Versie" HeaderText="Versie" 
                SortExpression="Versie" />
            <asp:BoundField DataField="Naam" HeaderText="Naam" SortExpression="Bedrijf" />
            <asp:BoundField DataField="Taal" HeaderText="Taal" SortExpression="Taal" />
            <asp:BoundField DataField="Is_final" HeaderText="Finale Versie" 
                SortExpression="Is_final" />
            <asp:CommandField ButtonType="Image" 
                SelectImageUrl="~/App_Presentation/CSS/images/remove.png" 
                ShowSelectButton="True" />
        </Columns>
    </asp:GridView>
    
</div>

<asp:Label runat="server" ID="lblSelecteerArtikel" Text="Selecteer een artikel om te verwijderen." Visible="false"></asp:Label>

<asp:Label ID="lblRes" runat="server"></asp:Label>
    </ContentTemplate>
    </asp:UpdatePanel>


</asp:Content>

