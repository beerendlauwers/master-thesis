<%@ Page Language="VB" AutoEventWireup="false" CodeFile="FiliaalBeheer.aspx.vb" Inherits="App_Presentation_Webpaginas_FiliaalBeheer" MasterPageFile="~/App_Presentation/MasterPage.master" %>
<asp:Content ID="Main" ContentPlaceHolderID="plcMain" runat="server">
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>FiliaalBeheer</title>
</head>
<body>
    <table>
    <tr>
    <td>
    <div>
        <asp:Label ID="Label2" runat="server" Text="Filiaal Toevoegen:"></asp:Label>
    </div>
    
    <div>
        <asp:Label ID="lblFiliaalNaam" runat="server" Text="FiliaalNaam: "> </asp:Label><asp:TextBox ID="txtFiliaalNaam"
            runat="server"></asp:TextBox>
            <br />
        <asp:Label ID="lblFiliaalLocatie" runat="server" Text="Locatie: "> </asp:Label><asp:TextBox
            ID="txtLocatie" runat="server"></asp:TextBox>
            <br />
        <asp:Label ID="lblLongitude" runat="server" Text="Straat + Nr: "></asp:Label>
        <asp:TextBox
            ID="txtAdres" runat="server"></asp:TextBox>
            <br />
            <br /><br />
            <asp:Button ID="btnVoegtoe" runat="server" Text="Voeg filiaal toe" />
    </div>
    </td>
    <td>
        <asp:Label ID="lblDelete" runat="server" Text="Verwijder Filiaal"></asp:Label>
        <br />  
        <asp:Label
            ID="lblInstructie" runat="server" Text="Selecteer Filiaal:"></asp:Label>
        <asp:DropDownList ID="ddlFiliaal" runat="server" 
            DataSourceID="objdFiliaalDelete" DataTextField="filiaalNaam" 
            DataValueField="filiaalID">
        </asp:DropDownList>
        <br />
        <br />
        <asp:Button ID="btnDelete" runat="server" Text="Verwijder" />
        
        <asp:ObjectDataSource ID="objdFiliaalDelete" runat="server" 
            DeleteMethod="Delete" InsertMethod="Insert" 
            OldValuesParameterFormatString="original_{0}" SelectMethod="GetData" 
            TypeName="Auto_sTableAdapters.tblFiliaalTableAdapter" UpdateMethod="Update">
            <DeleteParameters>
                <asp:Parameter Name="Original_filiaalID" Type="Int32" />
            </DeleteParameters>
            <UpdateParameters>
                <asp:Parameter Name="filiaalLocatie" Type="String" />
                <asp:Parameter Name="filiaalNaam" Type="String" />
                <asp:Parameter Name="filiaalLongitude" Type="String" />
                <asp:Parameter Name="filiaalLatitude" Type="String" />
                <asp:Parameter Name="Original_filiaalID" Type="Int32" />
            </UpdateParameters>
            <InsertParameters>
                <asp:Parameter Name="filiaalLocatie" Type="String" />
                <asp:Parameter Name="filiaalNaam" Type="String" />
                <asp:Parameter Name="filiaalLongitude" Type="String" />
                <asp:Parameter Name="filiaalLatitude" Type="String" />
            </InsertParameters>
        </asp:ObjectDataSource>
        
    </td>
    </tr>
    </table>
    
</body>
</html>
</asp:Content>