<%@ Page Language="VB" EnableEventValidation="false" MasterPageFile="~/App_Presentation/MasterPage.master"
    AutoEventWireup="false" CodeFile="ReservatieWijzigen.aspx.vb" Inherits="App_Presentation_Webpaginas_GebruikersOnly_ToonReservatie"
    Title="Reservatie Wijzigen" %>


<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="plcMain" runat="Server">
<h1>Reservatie wijzigen</h1>
    <asp:UpdatePanel ID="updReservatieWijzigen" runat="server" UpdateMode="Always">
        <ContentTemplate>
            <asp:Image ID="imgReservatieAangepast" runat="server" ImageUrl="~/App_Presentation/Images/tick.gif" Visible="false" /><asp:Label ID="lblReservatieAangepast" runat="server" Visible="false" Text= "Uw reservatie werd aangepast."></asp:Label>
            <br />
            <table>
                <tr>
                    <th colspan="2">
                        <asp:Label ID="lblMerkModel" runat="server"></asp:Label>
                    </th>
                </tr>
                <tr>
                    <td runat="server" id="tdFoto">
                        <img runat="server" id="imgFoto" />
                    </td>
                    <td>
                        <cc1:Accordion ID="ReservatieAccordion" runat="server" AutoSize="None" TransitionDuration="250"
                            HeaderCssClass="art-BlockHeaderStrong">
                            <Panes>
                                <cc1:AccordionPane ID="PanePeriode" runat="server">
                                    <Header>
                                        <asp:Image ID="imgPeriode" runat="server" ImageAlign="Top" ImageUrl="~/App_Presentation/Images/wrench.png" />&nbsp;Periode
                                        Wijzigen</Header>
                                    <Content>
                                        Huidige periode: &nbsp;<asp:Label ID="lblPeriode" runat="server"></asp:Label>
                                        <table>
                                            <tr>
                                                <td>
                                                    Begindatum:
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txtBegindatum" runat="server" CausesValidation="True"></asp:TextBox>
                                                    <cc1:CalendarExtender ID="calBegindatum" runat="server" TargetControlID="txtBegindatum"
                                                        Format="d/MM/yyyy" FirstDayOfWeek="Monday" TodaysDateFormat="d MMMM, yyyy" PopupButtonID="imgBeginDatumKalender">
                                                    </cc1:CalendarExtender>
                                                    <asp:Image ImageAlign="AbsMiddle" ID="imgBeginDatumKalender" runat="server" ImageUrl="~/App_Presentation/Images/kalender.png" />
                                                    <asp:RequiredFieldValidator ID="valBegindatum" runat="server" ControlToValidate="txtBegindatum"
                                                        ErrorMessage="Dit veld is verplicht."></asp:RequiredFieldValidator>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    Einddatum:
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txtEinddatum" runat="server" CausesValidation="True"></asp:TextBox>
                                                    <cc1:CalendarExtender ID="calEinddatum" runat="server" TargetControlID="txtEinddatum"
                                                        Format="d/MM/yyyy" FirstDayOfWeek="Monday" TodaysDateFormat="d MMMM, yyyy" PopupButtonID="imgEindDatumKalender">
                                                    </cc1:CalendarExtender>
                                                    <asp:Image ImageAlign="AbsMiddle" ID="imgEindDatumKalender" runat="server" ImageUrl="~/App_Presentation/Images/kalender.png" />
                                                    <asp:RequiredFieldValidator ID="valEinddatum" runat="server" ControlToValidate="txtBegindatum"
                                                        ErrorMessage="Dit veld is verplicht."></asp:RequiredFieldValidator>
                                                </td>
                                            </tr>
                                        </table>
                                    </Content>
                                </cc1:AccordionPane>
                                <cc1:AccordionPane ID="PaneKleur" runat="server">
                                    <Header>
                                        <asp:Image ID="imgKleur" runat="server" ImageAlign="Top" ImageUrl="~/App_Presentation/Images/wrench.png" />&nbsp;Kleur
                                        Wijzigen</Header>
                                    <Content>
                                    Huidige kleur: <asp:Label ID="lblKleur" runat="server" Text="Label" ></asp:Label><br />
                                    <table>
                                    <tr>
                                    <td>Kleur: </td>
                                    <td>
                                        <asp:DropDownList ID="ddlKleur" runat="server">
                                        </asp:DropDownList>
                                    </td>
                                    </tr>
                                    </table>
                                    </Content>
                                </cc1:AccordionPane>
                                <cc1:AccordionPane ID="PaneOpties" runat="server">
                                    <Header>
                                        <asp:Image ID="imgOpties" runat="server" ImageAlign="Top" ImageUrl="~/App_Presentation/Images/wrench.png" />&nbsp;Opties
                                        Wijzigen</Header>
                                    <Content>
                                    <table>
                                    <tr>
                                    <td>Naam</td>
                                    <td>Kost</td>
                                    </tr>
                                        <asp:PlaceHolder ID="plcOpties" runat="server"></asp:PlaceHolder>
                                        </table>
                                    </Content>
                                </cc1:AccordionPane>
                            </Panes>
                        </cc1:Accordion>
                    </td>
                </tr>
            </table>
            <br />
            <div align="right">
                <asp:Button ID="btnBevestigen" runat="server" Text="Toon Aanbod" />

            </div>
            
            <asp:Panel ID="pnlAutoAanbod" runat="server" Visible="false">
            
            <asp:Image ID="imgResultaat" runat="server" />
            <asp:Label ID="lblResultaat" runat="server"></asp:Label>
            <asp:Label ID="lblGewenstePeriode" runat="server"></asp:Label>
            <table>    
            <tr>
                    <th>
                        Auto
                    </th>
                    <th>
                        Kleur
                    </th>
                    <th>
                        Totaalkost
                    </th>
                    <th>
                        &nbsp;
                    </th>
                    <th>
                        &nbsp;
                    </th>
                </tr>
            <asp:Repeater ID="RepBeschikbareAutos" runat="server" OnItemCommand="RepBeschikbareAutos_ItemCommand">
            <ItemTemplate >
            <tr style="background-color:#<%# DataBinder.Eval(Container.DataItem, "rijKleur")%>" >
            <td align="center">
                                <%# DataBinder.Eval(Container.DataItem, "autoNaam") %>
                            </td>
                            <td align="center">
                                <%#DataBinder.Eval(Container.DataItem, "autoKleur")%>
                            </td>
                            <td align="right">
                                <%#DataBinder.Eval(Container.DataItem, "totaalKost")%>
                            </td>
                            <td align="center">
                                <asp:Button ID="btnAutoKiezen" runat="server" Text="Deze auto kiezen" CommandArgument='<%#DataBinder.Eval(Container.DataItem, "autoID")%>' />
                            </td>
                            <td align="left">
                                <div style="display:<%#DataBinder.Eval(Container.DataItem, "huidigeAuto")%>">
                                <asp:Image ID="imgHuidigeAuto" runat="server" ImageUrl="~/App_Presentation/Images/pijllinks.png"  /> Dit is uw huidige auto.
                                </div>
                            </td>
                            </tr>
            </ItemTemplate>
            </asp:Repeater>
            </table>
            </asp:Panel>
            
            <asp:Label ID="lblOngeldigID" runat="server"></asp:Label>
        </ContentTemplate>
    </asp:UpdatePanel>
    
</asp:Content>
