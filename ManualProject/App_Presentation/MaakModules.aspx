<%@ Page Language="VB" MasterPageFile="~/App_Presentation/MasterPage.master" AutoEventWireup="false" CodeFile="MaakModules.aspx.vb" Inherits="App_Presentation_MaakModules" title="Untitled Page" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolderTitel" Runat="Server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
Klik op de knop alle modules aan te maken.<asp:GridView ID="GridView1" 
        runat="server" AutoGenerateColumns="False" DataSourceID="AccessDataSource1">
        <Columns>
            <asp:BoundField DataField="MDUL14" HeaderText="MDUL14" 
                SortExpression="MDUL14" />
        </Columns>
    </asp:GridView>
&nbsp;<asp:Button ID="btnMaakAan" runat="server" Text="Maak aan" />


    <asp:Button ID="btnVolledig" runat="server" Text="Vul Verder aan met ontbrekende modules." />


    <asp:AccessDataSource ID="AccessDataSource1" runat="server" DataFile="~/fr.mdb" 
        SelectCommand="SELECT [MDUL14] FROM [Product &amp; module]"></asp:AccessDataSource>
</asp:Content>

