<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Chauffeur.aspx.vb" Inherits="App_Presentation_Chauffeur" MasterPageFile="~/App_Presentation/MasterPage.master" %>
<asp:Content ID="Main" ContentPlaceHolderID="plcMain" runat="server">
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>chauffeur</title>
</head>
<body>
    <div>
    <table>
    <tr>
    <td align="right">
        <asp:Label ID="lblNaam" runat="server" Text="Naam chauffeur: "></asp:Label>
    </td>
    <td>
        <asp:TextBox ID="txtcNaam" runat="server"></asp:TextBox>
    </td>
    </tr>
    <tr>
    <td align="right">
        <asp:Label ID="lblVoornaam" runat="server" Text="Voornaam chauffeur: "></asp:Label>
    </td>
    <td>
        <asp:TextBox ID="txtcVoornaam" runat="server"></asp:TextBox>
    </td>
    </tr>
    <tr>
    <td align="right">
        <asp:Label ID="lblBedrijf" runat="server" Text="Bedrijf: "></asp:Label>
    </td>
    <td>
        <asp:TextBox ID="txtBedrijf" runat="server"></asp:TextBox>
    </td>
    </tr>
    <tr>   
    <td align="right">
        <asp:Button ID="btnInsert" runat="server" Text="Voeg toe" />
        <asp:ObjectDataSource ID="ObjectDataSource1" runat="server" 
            DeleteMethod="Delete" InsertMethod="Insert" 
            OldValuesParameterFormatString="original_{0}" SelectMethod="GetData" 
            TypeName="KlantenTableAdapters.tblChauffeurTableAdapter" UpdateMethod="Update">
            <DeleteParameters>
                <asp:Parameter Name="Original_ChauffeurID" Type="Int32" />
            </DeleteParameters>
            <UpdateParameters>
                <asp:Parameter Name="chauffeurNaam" Type="String" />
                <asp:Parameter Name="chauffeurVoornaam" Type="String" />
                <asp:Parameter Name="fk_KlantID" Type="Int32" />
                <asp:Parameter Name="Original_ChauffeurID" Type="Int32" />
            </UpdateParameters>
            <InsertParameters>
                <asp:Parameter Name="chauffeurNaam" Type="String" />
                <asp:Parameter Name="chauffeurVoornaam" Type="String" />
                <asp:Parameter Name="fk_KlantID" Type="Int32" />
            </InsertParameters>
        </asp:ObjectDataSource>
    </td>
    </tr>
    </table>
    </div>
</body>
</html>
</asp:Content>

