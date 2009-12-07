<%@ Page Language="VB" EnableEventValidation="false" MasterPageFile="~/App_Presentation/MasterPage.master"
    AutoEventWireup="false" CodeFile="ReservatieWijzigen.aspx.vb" Inherits="App_Presentation_Webpaginas_GebruikersOnly_ToonReservatie"
    Title="Untitled Page" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="plcMain" runat="Server">
    <asp:ScriptManager ID="scmReservatieWijzigen" runat="server">
    </asp:ScriptManager>
    <asp:UpdatePanel ID="updReservatieWijzigen" runat="server" UpdateMode="Always">
        <ContentTemplate>
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
                <asp:Button ID="btnBevestigen" runat="server" Text="Reservatie Wijzigen" />
                <asp:Image ID="imgResultaat" runat="server" />
                <asp:Label ID="lblResultaat" runat="server" Visible="false"></asp:Label>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
    <asp:Label ID="lblOngeldigID" runat="server"></asp:Label>
</asp:Content>
