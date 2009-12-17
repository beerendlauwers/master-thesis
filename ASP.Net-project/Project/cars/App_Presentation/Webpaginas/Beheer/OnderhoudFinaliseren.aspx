<%@ Page Language="VB" MasterPageFile="~/App_Presentation/MasterPage.master" AutoEventWireup="false"
    CodeFile="OnderhoudFinaliseren.aspx.vb" Inherits="App_Presentation_Webpaginas_Beheer_OnderhoudFinaliseren"
    Title="Untitled Page" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="plcMain" runat="Server">
    
   
    <asp:UpdatePanel ID="updOnderhoudFinaliseren" runat="server">
        <ContentTemplate>
                <h1>Onderhoud Finaliseren</h1>
        <div align="center">
            <div runat="server" id="divKlantKosten">
            
            <asp:PlaceHolder runat="server" ID="plcKostenVoorKlanten"></asp:PlaceHolder>
                            
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
            <strong>Na het finaliseren van een onderhoud kan dit niet meer worden gewijzigd.<br />Alle kosten worden weggeschreven en kunnen niet meer worden aangepast.</strong>
                <br /><br />
            <asp:Button ID="btnOnderhoudFinaliseren" runat="server" Text="Onderhoud finaliseren" />
                        <div runat="server" id="divFeedback" visible="false">
                <asp:Image ID="imgFeedback" runat="server" />&nbsp;<asp:Label ID="lblFeedback" runat="server"></asp:Label> 
            </div>
            <br />
            <a href="Onderhoudbeheer.aspx">Terug naar Onderhoudbeheer</a>
                </div> 
        </ContentTemplate>
    </asp:UpdatePanel>

    <div runat="server" id="divError" visible="false">
    <h1>Er is een fout gebeurd.</h1>
    <asp:Label ID="lblFout" runat="server"></asp:Label><br /><br />
    <a href="Onderhoudbeheer.aspx">Terug naar Onderhoudbeheer</a>
    </div>
</asp:Content>
