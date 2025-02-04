﻿<%@ Page Language="VB" MasterPageFile="~/App_Presentation/MasterPage.master" AutoEventWireup="false"
    CodeFile="ReservatieBevestigen.aspx.vb" Inherits="App_Presentation_Webpaginas_ReservatieBevestigen"
    Title="Reservatie Bevestigen" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
<h1>Reservatie bevestigen</h1>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="plcMain" runat="Server">
    <asp:UpdatePanel ID="updReservatieBevestigen" runat="server" Visible="false">
        <ContentTemplate>
            <table>
                <tr>
                    <td colspan="3">
                        <asp:Label ID="lblMerkModel" runat="server"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td runat="server" id="tdFoto">
                        <img runat="server" id="imgFoto" />
                    </td>
                </tr>
                <tr>
                    <td>
                        Periode:
                    </td>
                    <td>
                        <asp:Label ID="lblPeriode" runat="server"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td>
                        Huurprijs:
                    </td>
                    <td>
                        <asp:Label ID="lblHuurPrijs" runat="server"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td>
                        Kleur:
                    </td>
                    <td>
                        <asp:Label ID="lblKleur" runat="server"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        Opties:
                    </td>
                </tr>
                <tr>
                    <td>
                        Naam
                    </td>
                    <td>
                        Kost
                    </td>
                </tr>
                <asp:PlaceHolder ID="plcOpties" runat="server"></asp:PlaceHolder>
                <tr>
                    <td colspan="3" align="center">
                        <asp:Button ID="btnBevestigen" runat="server" Text="Reservatie Bevestigen" /> 
                        <asp:Image ID="imgResultaat" runat="server" /> <asp:Label
                            ID="lblResultaat" runat="server" Visible="false"></asp:Label>
                    </td>
                </tr>
            </table>
        </ContentTemplate>
    </asp:UpdatePanel>
    <div runat="server" id="divFoutmelding" visible="false">
    <h2>Er is een fout gebeurd.</h2>
    <asp:Label ID="lblFoutDetails" runat="server"></asp:Label><br /><br />
    <a href="Default.aspx">Terug naar hoofdmenu</a>
    </div>
    <div runat="server" id="divInloggen" visible="false">
    <h2>U bent niet ingelogd.</h2>
    Gelieve in te loggen via het formulier aan de rechterkant.<br />
    Heeft u nog geen gebruikersaccount? Klik dan hier: 
        <asp:LinkButton ID="lnbNieuweGebruiker" OnClick="AnoniemeGebruikerDoorsturen" runat="server">Nieuwe gebruiker aanmaken</asp:LinkButton>
    </div>
</asp:Content>
