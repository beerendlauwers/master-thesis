<%@ Page Language="VB" MasterPageFile="~/App_Presentation/MasterPage.master" AutoEventWireup="false" CodeFile="Factuurbeheer.aspx.vb" Inherits="App_Presentation_Webpaginas_Beheer_Factuurbeheer" title="Untitled Page" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="plcMain" Runat="Server">

    <asp:UpdatePanel ID="updFactuurBeheer" runat="server">
    <ContentTemplate>
    
        <cc1:TabContainer ID="tabFactuurBeheer" runat="server">
        <cc1:TabPanel HeaderText="Facturen In Wacht" ID="tabFacturenInWacht" runat="server">
        <ContentTemplate>
        
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
                        Totaalkost
                    </th>
                    <th>
                        &nbsp;
                    </th>
                </tr>
                <asp:Repeater ID="repOverzicht" runat="server">
                    <ItemTemplate>
                        <tr style="background-color:#<%# DataBinder.Eval(Container.DataItem, "rijKleur") %>">
                            <td align="center">
                                <%# DataBinder.Eval(Container.DataItem, "autoNaam") %>
                            </td>
                            <td align="center">
                                <%#DataBinder.Eval(Container.DataItem, "autoKleur")%>
                            </td>
                            <td align="center">
                                <%# DataBinder.Eval(Container.DataItem, "Begindatum") %>
                            </td>
                            <td align="center">
                                <%#DataBinder.Eval(Container.DataItem, "Einddatum")%>
                            </td>
                            <td align="center">
                                <%#DataBinder.Eval(Container.DataItem, "totaalKost")%>
                            </td>
                            <td align="center">
                                <asp:ImageButton ID="imgButton" runat="server" ImageUrl="~/App_Presentation/Images/papier.png"
                                    CommandArgument='<%#DataBinder.Eval(Container.DataItem, "reservatieID")%>' />
                            </td>
                        </tr>
                    </ItemTemplate>
                </asp:Repeater>
            </table>
        
        
        </ContentTemplate>
        </cc1:TabPanel>
        <cc1:TabPanel HeaderText="Facturatiehistoriek" ID="tabFactuurHistoriek">
        <ContentTemplate>
                </ContentTemplate>
        </cc1:TabPanel>
        </cc1:TabContainer>
    
    </ContentTemplate>
    </asp:UpdatePanel>

</asp:Content>

