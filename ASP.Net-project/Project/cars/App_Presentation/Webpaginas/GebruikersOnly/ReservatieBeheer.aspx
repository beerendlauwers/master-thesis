<%@ Page Language="VB" enableEventValidation="false" MasterPageFile="~/App_Presentation/MasterPage.master" AutoEventWireup="false"
    CodeFile="ReservatieBeheer.aspx.vb" Inherits="App_Presentation_Webpaginas_GebruikersOnly_ToonReservatie"
    Title="Untitled Page" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="plcMain" runat="Server">
    <asp:Panel ID="pnlOverzicht" runat="server">
            <table>
                <tr>
                    <th>
                        Auto
                    </th>
                    <th>
                        Kleur
                    </th>
                    <th>
                        Begindatum
                    </th>
                    <th>
                        Einddatum
                    </th>
                    <th>
                        # Dagen
                    </th>
                    <th>
                        # Opties
                    </th>
                    <th>
                        Totaalkost
                    </th>
                    <th>
                        &nbsp;
                    </th>
                </tr>
                <asp:Repeater ID="repOverzicht" runat="server" OnItemCommand="repOverzicht_ItemCommand">
                    <ItemTemplate>
                        <tr style="background-color:#<%# DataBinder.Eval(Container.DataItem, "rijKleur") %>">
                            <td align="center">
                                <%# DataBinder.Eval(Container.DataItem, "autoNaam") %>
                            </td>
                            <td align="center">
                                <%#DataBinder.Eval(Container.DataItem, "autoKleur")%>
                            </td>
                            <td align="center">
                                <%#(CType(Container.DataItem, System.Data.DataRowView)("begindat")).ToShortDateString()%> 
                            </td>
                            <td align="center">
                                <%#(CType(Container.DataItem, System.Data.DataRowView)("einddat")).ToShortDateString()%> 
                            </td>
                            <td align="center">
                                 <%#DataBinder.Eval(Container.DataItem, "aantalDagen")%>
                            </td>
                            <td align="center">
                                <%#DataBinder.Eval(Container.DataItem, "aantalOpties")%>
                            </td>
                            <td align="right">
                                <%#DataBinder.Eval(Container.DataItem, "totaalKost")%>
                            </td>
                            <td align="center">
                                <asp:ImageButton ID="imgButton" runat="server" ImageUrl="~/App_Presentation/Images/wrench.png"
                                    CommandArgument='<%#DataBinder.Eval(Container.DataItem, "resData")%>' />
                            </td>
                        </tr>
                    </ItemTemplate>
                </asp:Repeater>
            </table>
        </asp:Panel>
    <asp:Label ID="lblGeenReservaties" runat="server" Text="Label"></asp:Label>
</asp:Content>
