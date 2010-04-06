<%@ Page Language="VB" MasterPageFile="~/App_Presentation/MasterPage.master" AutoEventWireup="false" CodeFile="page.aspx.vb" Inherits="App_Presentation_page" title="Untitled Page" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <asp:Label ID="lblTitel" CssClass="h1" runat="server" Text="Label"></asp:Label>
    <br /><br />
    <asp:Label ID="lblTekst" runat="server"></asp:Label>
    <asp:Label ID="lblTag" runat="server" Visible="false"></asp:Label>
    <asp:Label ID="lblForm" runat="server" Text=""></asp:Label>
</asp:Content>

