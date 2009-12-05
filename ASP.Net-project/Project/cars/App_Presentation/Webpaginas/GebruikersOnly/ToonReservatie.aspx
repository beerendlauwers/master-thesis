<%@ Page Language="VB" MasterPageFile="~/App_Presentation/MasterPage.master" AutoEventWireup="false"
    CodeFile="ToonReservatie.aspx.vb" Inherits="App_Presentation_Webpaginas_GebruikersOnly_ToonReservatie"
    Title="Untitled Page" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="plcMain" runat="Server">
    <asp:LoginView ID="lgvReservatie" runat="server">
        <LoggedInTemplate>
            <table>
                <tr>
                    <td>
                        Kenteken
                    </td>
                    <td>
                        Auto
                    </td>
                    <td>
                        Begindatum
                    </td>
                    <td>
                        Einddatum
                    </td>
                </tr>
                <asp:Repeater ID="repOverzicht" runat="server">
                    <ItemTemplate>
                        <tr>
                            <td>
                                <%# DataBinder.Eval(Container.DataItem, "autoKenteken") %>
                            </td>
                            <td>
                                <%# DataBinder.Eval(Container.DataItem, "autoNaam") %>
                            </td>
                            <td>
                                <%# DataBinder.Eval(Container.DataItem, "begindat") %>
                            </td>
                            <td>
                                <%# DataBinder.Eval(Container.DataItem, "einddat") %>
                            </td>
                        </tr>
                    </ItemTemplate>
                </asp:Repeater>
            </table>
        </LoggedInTemplate>
    </asp:LoginView>
    <asp:Label ID="lblGeenReservaties" runat="server" Text="Label"></asp:Label>
</asp:Content>
