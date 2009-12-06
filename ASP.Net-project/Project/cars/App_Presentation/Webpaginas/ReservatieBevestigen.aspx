<%@ Page Language="VB" MasterPageFile="~/App_Presentation/MasterPage.master" AutoEventWireup="false"
    CodeFile="ReservatieBevestigen.aspx.vb" Inherits="App_Presentation_Webpaginas_ReservatieBevestigen"
    Title="Untitled Page" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="plcMain" runat="Server">
    <asp:ScriptManager ID="scmReservatieBevestigen" runat="server">
    </asp:ScriptManager>
    <asp:UpdatePanel ID="updReservatieBevestigen" runat="server">
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
</asp:Content>
