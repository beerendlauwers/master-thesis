<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Chauffeur.aspx.vb" Inherits="App_Presentation_Chauffeur"
    MasterPageFile="~/App_Presentation/MasterPage.master" %>

<asp:Content ID="Main" ContentPlaceHolderID="plcMain" runat="server">
    <div>
        <table>
            <tr>
                <td align="right">
                    <asp:Label ID="lblNaam" runat="server" Text="Naam chauffeur: "></asp:Label>
                </td>
                <td>
                    <asp:TextBox ID="txtNaam" runat="server"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td align="right">
                    <asp:Label ID="lblVoornaam" runat="server" Text="Voornaam chauffeur: "></asp:Label>
                </td>
                <td>
                    <asp:TextBox ID="txtVoornaam" runat="server"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td align="right">
                    <asp:Label ID="lblRijbewijs" runat="server" Text="Rijbewijs chauffeur: "></asp:Label>
                </td>
                <td>
                    <asp:TextBox ID="txtRijbewijs" runat="server"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td align="right">
                    <asp:Label ID="lblBedrijf" runat="server" Text="Bedrijf: "></asp:Label>
                </td>
                <td>
                    <asp:DropDownList ID="ddlBedrijf" runat="server"></asp:DropDownList>
                </td>
            </tr>
            <tr>
                <td align="right">
                    <asp:Button ID="btnInsert" runat="server" Text="Voeg toe" />
                </td>
            </tr>
        </table>
    </div>
</asp:Content>
