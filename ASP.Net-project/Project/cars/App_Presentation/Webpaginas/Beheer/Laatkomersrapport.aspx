<%@ Page Language="VB" MasterPageFile="~/App_Presentation/MasterPage.master" AutoEventWireup="false" CodeFile="Laatkomersrapport.aspx.vb" Inherits="App_Presentation_Webpaginas_Beheer_Laatkomersrapport" title="Untitled Page" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="plcMain" Runat="Server">

   <h1>Laatkomersrapport</h1>
   
    <asp:Label ID="lblGeenLaatkomers" runat="server" Visible="false"></asp:Label>
    <asp:UpdatePanel ID="updLaatkomersRapport" runat="server">
    <ContentTemplate>
    
    <table>
    <tr>
    <th>Kenteken</th>
    <th>Merk En Model</th>
    <th>Begindatum</th>
    <th>Einddatum</th>
    <th>Klant</th>
    <th>Uitgecheckt door<br />medewerker</th>
    </tr>
        <asp:Repeater ID="repLaatkomersrapport" runat="server">
        <ItemTemplate>
        <tr>
        <td align="center"><%#DataBinder.Eval(Container.DataItem, "Kenteken")%></td>
        <td align="center"><%#DataBinder.Eval(Container.DataItem, "MerkModel")%></td>
        <td align="center"><%#DataBinder.Eval(Container.DataItem, "Begindatum")%></td>
        <td align="center"><%#DataBinder.Eval(Container.DataItem, "Einddatum")%></td>
        <td align="center"><%#DataBinder.Eval(Container.DataItem, "Klant")%></td>
        <td align="center"><%#DataBinder.Eval(Container.DataItem, "Medewerker")%></td>
        </tr>
        </ItemTemplate>
        </asp:Repeater>
    </table>
    
    </ContentTemplate>
    </asp:UpdatePanel>

</asp:Content>

