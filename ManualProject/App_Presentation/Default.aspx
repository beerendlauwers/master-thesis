<%@ Page Language="VB" MasterPageFile="~/App_Presentation/MasterPage.master" AutoEventWireup="false" CodeFile="Default.aspx.vb" Inherits="App_Presentation_Default" EnableEventValidation="false"  EnableViewStateMac="False"  title="Untitled Page" %>
<%@ MasterType VirtualPath="~/App_Presentation/MasterPage.master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<p>
    <asp:Label ID="lblWelkom" runat="server" Text=""></asp:Label>
</p>
</asp:Content>