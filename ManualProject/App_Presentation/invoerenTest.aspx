<%@ Page Language="VB" MasterPageFile="~/App_Presentation/MasterPage.master" AutoEventWireup="false" CodeFile="invoerenTest.aspx.vb" Inherits="App_Presentation_invoerenTest" title="Untitled Page" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit.HTMLEditor"
    TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <title>Artikel toevoegen</title>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">


    <br />
    <br />
    <asp:Label ID="lbltitel" runat="server" Text="Titel: "></asp:Label>
    <asp:TextBox ID="txtTitel" runat="server"></asp:TextBox>
    <br />
    <br />
    <asp:Label ID="lblTag" runat="server" Text="Tag: "></asp:Label>
&nbsp;<asp:TextBox ID="txtTag" runat="server"></asp:TextBox>
    <br />
    <br />
    <asp:Label ID="lblCategorie" runat="server" Text="Categorie: "></asp:Label>
<asp:DropDownList ID="ddlCategorie" runat="server">
</asp:DropDownList>
    <br />
    <br />


    <cc1:Editor ID="Editor1" runat="server" height="300px" Width="450px"/>

    <br />

</asp:Content>

