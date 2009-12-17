<%@ Page Language="VB" MasterPageFile="~/App_Presentation/MasterPage.master" AutoEventWireup="false" CodeFile="FactuurDetails.aspx.vb" Inherits="App_Presentation_Webpaginas_Beheer_FactuurDetails" title="Untitled Page" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="plcMain" Runat="Server">

<h1>Factuurdetails</h1>

    <asp:UpdatePanel ID="updFactuurDetails" runat="server">
    <ContentTemplate>

<h3>Algemene details</h3>

    <table>
    <tr>
    <td>Kenteken</td>
    <td><asp:Label ID="lblKenteken" runat="server"></asp:Label></td>
    </tr>
    <tr>
    <td>Merk En Model</td>
    <td><asp:Label ID="lblMerkModel" runat="server"></asp:Label></td>
    </tr>
    <tr>
    <td>Begindatum</td>
    <td><asp:Label ID="lblBegindatum" runat="server"></asp:Label></td>
    </tr>
    <tr>
    <td>Einddatum</td>
    <td><asp:Label ID="lblEinddatum" runat="server"></asp:Label></td>
    </tr>
    <tr>
    <td>Klant</td>
    <td><asp:Label ID="lblKlant" runat="server"></asp:Label></td>
    </tr>
    </table>
    <br />
    <h3>Factuurlijnen</h3>
            <table>
                <tr>
                    <th>
                        Omschrijving
                    </th>
                    <th>
                        Kost
                    </th>
                    <th>
                        Code
                    </th>
                </tr>
                <asp:Repeater ID="repOverzicht" runat="server">
                    <ItemTemplate>
                        <tr style="background-color:#<%# DataBinder.Eval(Container.DataItem, "rijKleur") %>">
                            <td align="center">
                                <%#DataBinder.Eval(Container.DataItem, "Code")%>
                            </td>
                            <td align="center">
                                <%#DataBinder.Eval(Container.DataItem, "Omschrijving")%>
                            </td>
                            <td align="center">
                                <%#DataBinder.Eval(Container.DataItem, "Kost")%>
                            </td>
                        </tr>
                    </ItemTemplate>
                </asp:Repeater>
            </table>
            
            <h3>Openstaande beschadigingen</h3>
                <table>
                <tr>
                    <th>
                        Omschrijving
                    </th>
                   <th>
                        Is Hersteld
                    </th>
                    <th>
                        Kost
                    </th>
                    <th>
                        Is Doorverrekend
                    </th>

                </tr>
                <asp:Repeater ID="repBeschadigingen" runat="server">
                    <ItemTemplate>
                        <tr style="background-color:#<%# DataBinder.Eval(Container.DataItem, "rijKleur") %>">
                            <td align="center">
                                <%#DataBinder.Eval(Container.DataItem, "Omschrijving")%>
                            </td>
                            <td align="center">
                                <%#DataBinder.Eval(Container.DataItem, "IsHersteld")%>
                            </td>
                            <td align="center">
                                <%#DataBinder.Eval(Container.DataItem, "Kost")%>
                            </td>
                            <td align="center">
                                <%#DataBinder.Eval(Container.DataItem, "IsDoorverrekend")%>
                            </td>
                        </tr>
                    </ItemTemplate>
                </asp:Repeater>
            </table>
    
    </ContentTemplate>
    </asp:UpdatePanel>

</asp:Content>

