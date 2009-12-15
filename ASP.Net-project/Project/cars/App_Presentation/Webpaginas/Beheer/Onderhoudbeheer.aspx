<%@ Page Language="VB" MasterPageFile="~/App_Presentation/MasterPage.master" AutoEventWireup="false"
    CodeFile="Onderhoudbeheer.aspx.vb" Inherits="App_Presentation_Webpaginas_Beheer_Onderhoudbeheer"
    Title="Onderhoudbeheer" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">

    <style type="text/css">
        .art-legende
        {
            background-color: #D2D2D0;
            padding: 5px 5px 5px 5px;
            border: dashed 1px black;
        }
    </style>
    
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="plcMain" runat="Server">
    <h1>Onderhoudbeheer</h1>
    <asp:UpdatePanel ID="updOnderhoudBeheer" runat="server">
        <ContentTemplate>
        <h2>Gepland onderhoud voor vandaag</h2>
                        <asp:Label ID="lblGeenOnderhoudVandaag" runat="server" Visible="false"></asp:Label>
                        <div
                            runat="server" id="divOnderhoudVandaag">
                            <table>
                                <tr>
                                    <th>
                                        Kenteken
                                    </th>
                                    <th>
                                        Merk en model
                                    </th>
                                    <th>
                                        Omschrijving
                                    </th>
                                    <th>
                                        &nbsp;
                                    </th>
                                </tr>
                                <asp:Repeater ID="repOnderhoudVoorVandaag" runat="server">
                                    <ItemTemplate>
                                        <tr>
                                            <td>
                                                <%#DataBinder.Eval(Container.DataItem, "Kenteken")%>
                                            </td>
                                            <td>
                                                <%#DataBinder.Eval(Container.DataItem, "MerkModel")%>
                                            </td>
                                            <td>
                                                <%#DataBinder.Eval(Container.DataItem, "Omschrijving")%>
                                            </td>
                                            <td>
                                                <a href="NieuwOnderhoud.aspx?=<%# DataBinder.Eval(Container.DataItem, "controleID") %>">
                                                    Ga naar onderhoud</a>
                                            </td>
                                        </tr>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </table>
                        </div>
        <br /><br />
        
        <h2>Onderhoud per auto</h2>
        
                        <table>
                        <tr>
                        <td>
                        Selecteer Auto:&nbsp;
                        <asp:DropDownList ID="ddlAutos" runat="server" AutoPostBack="true" DataTextField="autoKenteken" DataValueField="autoID">
                        </asp:DropDownList>&nbsp;<asp:Label ID="lblAuto" runat="server"></asp:Label>
                        </td>
                        <td>
                        <asp:UpdateProgress ID="prgToekomstigOnderhoud" AssociatedUpdatePanelID="updOnderhoudBeheer" runat="server">
                        <ProgressTemplate>
                        <span>
                            <img src="../../Images/ajax-loader.gif" /> Even wachten aub...
                        </span>
                        </ProgressTemplate>
                        </asp:UpdateProgress>
                        </td>
                        </tr>
                        </table>
                        <br />
            <cc1:TabContainer runat="server" ID="tabOnderhoudBeheer" ActiveTabIndex="3" 
                Width="100%">
                <cc1:TabPanel ID="tabOnderhoudsbeheer" runat="server" HeaderText="Nieuw Onderhoud Plannen">
                <ContentTemplate>
                <table>
                <tr>
                <td>
                
                <table>
<tr>
        <td>Begindatum:</td>
        <td>
            <asp:TextBox ID="txtBegindatum" runat="server" CausesValidation="True"></asp:TextBox>
            <cc1:CalendarExtender ID="calBegindatum" runat="server" 
                TargetControlID="txtBegindatum" Format="d/MM/yyyy" FirstDayOfWeek="Monday" 
                TodaysDateFormat="d MMMM, yyyy" PopupButtonID="imgBeginDatumKalender"></cc1:CalendarExtender>
            <asp:Image ImageAlign="AbsMiddle" ID="imgBeginDatumKalender" runat="server" ImageUrl="~/App_Presentation/Images/kalender.png" /> 
            <asp:RequiredFieldValidator ID="valBegindatum" runat="server" ControlToValidate="txtBegindatum" ErrorMessage="Dit veld is verplicht."></asp:RequiredFieldValidator>
            <cc1:MaskedEditExtender ID="mskBeginDatum" runat="server" TargetControlID="txtBegindatum" Mask="99/99/9999" MaskType="Date" MessageValidatorTip="False" PromptCharacter="." ClearMaskOnLostFocus="False" ClearTextOnInvalid="True">
            </cc1:MaskedEditExtender>
        </td>
        </tr>
        <tr>
        <td>Einddatum:</td>
        <td>
            <asp:TextBox ID="txtEinddatum" runat="server" CausesValidation="True"></asp:TextBox>
            <cc1:CalendarExtender ID="calEinddatum" runat="server" 
                TargetControlID="txtEinddatum" Format="d/MM/yyyy" FirstDayOfWeek="Monday" TodaysDateFormat="d MMMM, yyyy" PopupButtonID="imgEindDatumKalender"></cc1:CalendarExtender>
                <asp:Image ImageAlign="AbsMiddle" ID="imgEindDatumKalender" runat="server" ImageUrl="~/App_Presentation/Images/kalender.png" /> 
            <asp:RequiredFieldValidator ID="valEinddatum" runat="server" ControlToValidate="txtBegindatum" ErrorMessage="Dit veld is verplicht."></asp:RequiredFieldValidator>
            <cc1:MaskedEditExtender ID="mskEindDatum" runat="server" TargetControlID="txtEinddatum" Mask="99/99/9999" MaskType="Date" MessageValidatorTip="False" PromptCharacter="." ClearMaskOnLostFocus="False" ClearTextOnInvalid="True">
            </cc1:MaskedEditExtender>
        </td>
        </tr>
        <tr>
        <td>Omschrijving:</td>
        <td><textarea runat="server" id="txtOmschrijving" rows="4" cols="20"></textarea></td>
        </tr>
        <tr>
        <td colspan="2">
            <asp:Image ID="imgFeedback" runat="server" />&nbsp;<asp:Label ID="lblFeedback" runat="server" ForeColor=Red></asp:Label></td>
        </tr>
        <tr>
        <td colspan="2" align="center">
            <asp:Button ID="btnOnderhoudPlannen" runat="server" Text="Plan onderhoud" /></td>
        </tr>
                </table>
                
                </td>
                <td align="center">
                <asp:Calendar ID="calAutoSchema" runat="server" BackColor="White" 
                BorderColor="White" BorderWidth="1px" Font-Names="Verdana" Font-Size="9pt" 
                ForeColor="Black" NextPrevFormat="FullMonth" Width="50%" SelectionMode=None>
                <SelectedDayStyle BackColor="#333399" ForeColor="White" />
                <TodayDayStyle BackColor="#CCCCCC" />
                <OtherMonthDayStyle ForeColor="#999999" />
                <NextPrevStyle Font-Bold="True" Font-Size="8pt" ForeColor="#333333" 
                VerticalAlign="Bottom" />
                <DayHeaderStyle Font-Bold="True" Font-Size="8pt" />
                <TitleStyle BackColor="White" BorderColor="Black" BorderWidth="4px" 
                Font-Bold="True" Font-Size="12pt" ForeColor="#333399" />
                </asp:Calendar>
                <div class="art-legende" align="center">
                        <b>Legende:</b><br />
                        <img src="../../Images/car.png" /> - Reservatie<br />
                        <img src="../../Images/wrench.png" /> - Gepland onderhoud<br />
                </div>
                </td>
                </tr>
                </table>
                </ContentTemplate>
                </cc1:TabPanel>
                <cc1:TabPanel ID="tabToekomstigOnderhoud" runat="server" HeaderText="Toekomstig gepland onderhoud">
                <ContentTemplate>
                    <asp:UpdatePanel runat="server" ID="updToekomstigOnderhoud">
                    <ContentTemplate>
                        <asp:Label ID="lblGeenToekomstigOnderhoud" runat="server" Visible="false"></asp:Label>
                        <div runat="server" id="divToekomstigOnderhoud">
                        
                        <div class="art-legende">
                        <b>Legende:</b><br />
                        <img src="../../Images/wrench.png" /> - Onderhoud uitvoeren / wijzigen<br />
                        <img src="../../Images/remove.png" /> - Onderhoud verwijderen<br />
                        </div>
                            <table>
                                <tr>
                                    <th>
                                        Begindatum
                                    </th>
                                    <th>
                                        Einddatum
                                    </th>
                                    <th>
                                        Omschrijving
                                    </th>
                                    <th>
                                        &nbsp;
                                    </th>
                                    <th>
                                        &nbsp;
                                    </th>
                                </tr>
                                <asp:Repeater ID="repToekomstigOnderhoud" runat="server">
                                    <ItemTemplate>
                                        <tr>
                                            <td>
                                                <%#DataBinder.Eval(Container.DataItem, "Begindatum")%>
                                            </td>
                                            <td>
                                                <%#DataBinder.Eval(Container.DataItem, "Einddatum")%>
                                            </td>
                                            <td>
                                                <%#DataBinder.Eval(Container.DataItem, "Omschrijving")%>
                                            </td>
                                            <td>
                                                <a href="NieuwOnderhoud.aspx?=<%# DataBinder.Eval(Container.DataItem, "controleID") %>">
                                                    <img src="../../Images/wrench.png" border="0" /></a>
                                            </td>
                                            <td>
                                                <asp:ImageButton ID="btnVerwijder" runat="server" ImageUrl="~/App_Presentation/Images/remove.png" CommandArgument='<%# DataBinder.Eval(Container.DataItem, "controleID") %>' />
                                            </td>
                                        </tr>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </table>
                        </div>
                        </ContentTemplate>
                        </asp:UpdatePanel>
                    </ContentTemplate>
                </cc1:TabPanel>
                <cc1:TabPanel ID="tabOnderhoudsHistoriek" runat="server" HeaderText="Onderhoudshistoriek">
                    <ContentTemplate>
                        <asp:UpdatePanel runat="server" ID="updOnderhoudsHistoriek">
                    <ContentTemplate>
                        <asp:Label ID="lblGeenOnderhoudsHistoriek" runat="server" Visible="false"></asp:Label>
                        <div runat="server" id="divOnderhoudsHistoriek" visible="false">
                            <table>
                                <tr>
                                    <th>
                                        Begindatum
                                    </th>
                                    <th>
                                        Einddatum
                                    </th>
                                    <th>
                                        Is Nazicht
                                    </th>
                                    <th>
                                        &nbsp;
                                    </th>
                                </tr>
                                <asp:Repeater ID="repOnderhoudsHistoriek" runat="server">
                                    <ItemTemplate>
                                        <tr>
                                            <td>
                                                <%#DataBinder.Eval(Container.DataItem, "Begindatum")%>
                                            </td>
                                            <td>
                                                <%#DataBinder.Eval(Container.DataItem, "Einddatum")%>
                                            </td>
                                            <td align="center">
                                                <%#DataBinder.Eval(Container.DataItem, "IsNazicht")%>
                                            </td>
                                            <td>
                                                <a href="NieuwOnderhoud.aspx?=<%# DataBinder.Eval(Container.DataItem, "controleID") %>">
                                                    Toon Details</a>
                                            </td>
                                        </tr>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </table>
                        </div>
                        </ContentTemplate>
                        </asp:UpdatePanel>
                        </ContentTemplate>
                </cc1:TabPanel>
            </cc1:TabContainer>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
