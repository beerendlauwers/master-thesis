<%@ Page Language="VB" MasterPageFile="~/App_Presentation/MasterPage.master" AutoEventWireup="false" CodeFile="Onderhoudbeheer.aspx.vb" Inherits="App_Presentation_Webpaginas_Beheer_Onderhoudbeheer" title="Onderhoudsbeheer" %>


<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="plcMain" Runat="Server">

    <h1>Onderhoudbeheer</h1>

    <asp:UpdatePanel ID="updOnderhoudBeheer" runat="server">
    <ContentTemplate>
    
    <cc1:TabContainer runat="server" id="tabOnderhoudBeheer" ActiveTabIndex="0" 
            Width="100%" Height="500" >
    <cc1:TabPanel runat="server" ID="tabOnderhoudVandaag" HeaderText="Gepland onderhoud voor vandaag">
        <ContentTemplate>
        <br />
            <asp:Label ID="lblGeenOnderhoudVandaag" runat="server" Visible="false"></asp:Label>
        <div runat="server" id="divOnderhoudVandaag">
        <table>
        <tr>
        <th>Kenteken</th>
        <th>Merk en model</th>
        <th>Omschrijving</th>
        <th>&nbsp;</th>
        </tr>
            <asp:Repeater ID="repOnderhoudVoorVandaag" runat="server">
            <ItemTemplate>
            <tr>
            <td><%#DataBinder.Eval(Container.DataItem, "Kenteken")%></td>
            <td><%#DataBinder.Eval(Container.DataItem, "MerkModel")%></td>
            <td><%#DataBinder.Eval(Container.DataItem, "Omschrijving")%></td>
            <td><a href="NieuwOnderhoud.aspx?=<%# DataBinder.Eval(Container.DataItem, "controleID") %>">Ga naar onderhoud</a></td>
            </tr>
            </ItemTemplate>
            </asp:Repeater>
        </table>
        </div>
        </ContentTemplate>
    </cc1:TabPanel>
        <cc1:TabPanel ID="tabToekomstigOnderhoud" runat="server" HeaderText="Toekomstig gepland onderhoud">
        <ContentTemplate>
            Dapman
        </ContentTemplate>
        </cc1:TabPanel>
        <cc1:TabPanel ID="tabOnderhoudsHistoriek" runat="server" HeaderText="Onderhoudshistoriek">
        <ContentTemplate>
            Dapman
        </ContentTemplate>
        </cc1:TabPanel>
    </cc1:TabContainer>
    
        Selecteer Auto:&nbsp;
        <asp:DropDownList ID="ddlAutos" runat="server" AutoPostBack="true"></asp:DropDownList>
    
    <h3>Nodig Onderhoud</h3>
    
        <table>
        <tr>
        <th>Begindatum</th>
        <th>Einddatum</th>
        <th>Omschrijving</th>
        <th>Is Nazicht</th>
        <th>&nbsp;</th>
        </tr>
            <asp:Repeater ID="repNodigOnderhoudOverzicht" runat="server">
            <ItemTemplate>
            <tr>
            <td><%#DataBinder.Eval(Container.DataItem, "Begindatum")%></td>
            <td><%#DataBinder.Eval(Container.DataItem, "Einddatum")%></td>
            <td><%#DataBinder.Eval(Container.DataItem, "Omschrijving")%></td>
            <td><%#DataBinder.Eval(Container.DataItem, "IsNazicht")%></td>
            <td style='display:<%#DataBinder.Eval(Container.DataItem, "Display")%>'>
                <a href="NieuwOnderhoud.aspx?=<%# DataBinder.Eval(Container.DataItem, "autoNaam") %>">Ga naar nazicht</a></td>
            </tr>
            </ItemTemplate>
            </asp:Repeater>
        </table>
    <br /><br />
    
    </ContentTemplate>
    </asp:UpdatePanel>


</asp:Content>

