<%@ Page Language="VB" MasterPageFile="~/App_Presentation/MasterPage.master" AutoEventWireup="false" CodeFile="verwijderenTekst.aspx.vb" Inherits="App_Presentation_verwijderenTekst" title="Untitled Page" %>

<%@ Register assembly="AjaxControlToolkit" namespace="AjaxControlToolkit" tagprefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">










    <p>
        Zoek een artikel op basis van de Titel:
    </p>
    <p>
        <asp:Label ID="lblSearch" runat="server" Text="Zoek: "></asp:Label>
        <asp:TextBox ID="txtSearch" runat="server"></asp:TextBox>
&nbsp;&nbsp;
        <asp:Label ID="lblWut" runat="server"></asp:Label>
    </p>
    <p>
        ----------------------------------------------</p>
    <p>
        Zoek een artikel op basis van een stuk Tekst:</p>
    <p>
        <asp:Label ID="lblZoekTekst" runat="server" Text="Zoek: "></asp:Label>
        <asp:TextBox ID="txtSearchText" runat="server"></asp:TextBox>
    </p>
    <p>
        &nbsp;&nbsp;<asp:Button ID="btnZoek" runat="server" Text="zoeken" />
    </p>
    <p>
        <asp:ListBox ID="ListBox1" runat="server">
            <asp:ListItem></asp:ListItem>
            <asp:ListItem></asp:ListItem>
        </asp:ListBox>
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Selecteer een artikel om te verwijderen.</p>
    <p>
        &nbsp;&nbsp;
        <asp:Button ID="btnVerwijder" runat="server" Text="Verwijder" />
    </p>










</asp:Content>

