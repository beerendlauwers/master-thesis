<%@ Page Language="VB" MasterPageFile="~/App_Presentation/MasterPage.master" AutoEventWireup="false" CodeFile="OnderhoudDetails.aspx.vb" Inherits="App_Presentation_Webpaginas_Beheer_OnderhoudDetails" title="Untitled Page" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="plcMain" Runat="Server">

    <asp:UpdatePanel ID="updOnderhoudDetails" runat="server">
    <ContentTemplate>
    <h1>Onderhoudsdetails</h1>
    
    <div runat="server" id="divBeschadigingen">
    
    <h2>Beschadigingen</h2>
    
    <table>
    <tr>
    <th>Klant die de<br />beschadiging<br />toebracht</th>
    <th>Omschrijving</th>
    <th>Is Hersteld</th>
    <th>Kost</th>
    </tr>
        <asp:Repeater ID="repOnderhoudBeschadiging" runat="server">
        <ItemTemplate>
        <tr>
        <td><%#DataBinder.Eval(Container.DataItem, "Klant")%></td>
        <td><%#DataBinder.Eval(Container.DataItem, "Omschrijving")%></td>
        <td><%#DataBinder.Eval(Container.DataItem, "IsHersteld")%></td>
        <td><%#DataBinder.Eval(Container.DataItem, "Kost")%></td>
        </tr>
        </ItemTemplate>
        </asp:Repeater>
    </table>
    </div>
    
    <div runat="server" id="divNazicht">
    <h2>Nazichtkosten</h2>
            <table>
            <tr>
            <td>Brandstofkost:</td>
            <td align="center"><asp:Label ID="lblBrandstofkost" runat="server"></asp:Label></td>
            </tr>
            <tr>
            </table>
    
    </div>
    
    <h2>Onderhoudsdetails</h2>
            <table>
            <tr>
            <td>Begindatum</td>
            <td align="center"><asp:Label ID="lblBeginDatum" runat="server"></asp:Label></td>
            </tr>
            <tr>
            <td>Einddatum</td>
            <td align="center"><asp:Label ID="lblEindDatum" runat="server"></asp:Label></td>
            </tr>
            <tr>
            <td>Uitgevoerd door<br />medewerker</td>
            <td align="center"><asp:Label ID="lblMedewerker" runat="server"></asp:Label></td>
            </tr>
            <tr>
            <td>Was nazicht</td>
            <td align="center"><asp:Label ID="lblWasNazicht" runat="server"></asp:Label></td>
            </tr>
            </table>
        <br /><br />
        <a href="Onderhoudbeheer.aspx">Terug naar Onderhoudbeheer</a>
    </ContentTemplate>
    </asp:UpdatePanel>
    <div runat="server" id="divError" visible="false">
    <h1>Er is een fout gebeurd.</h1>
    <asp:Label ID="lblFout" runat="server"></asp:Label><br /><br />
    <a href="Onderhoudbeheer.aspx">Terug naar Onderhoudbeheer</a>
    </div>
</asp:Content>

