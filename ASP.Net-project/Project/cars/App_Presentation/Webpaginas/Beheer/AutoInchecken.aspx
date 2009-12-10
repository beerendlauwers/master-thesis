<%@ Page Language="VB" MasterPageFile="~/App_Presentation/MasterPage.master" AutoEventWireup="false"
    CodeFile="AutoInchecken.aspx.vb" Inherits="App_Presentation_Webpaginas_Beheer_AutoInchecken"
    Title="Untitled Page" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="plcMain" runat="Server">
    <table>
        <tr>
            <td>
                Kenteken:
            </td>
            <td>
                <asp:DropDownList ID="ddlKenteken" runat="server">
                </asp:DropDownList>
            </td>
        </tr>
    </table>
</asp:Content>
