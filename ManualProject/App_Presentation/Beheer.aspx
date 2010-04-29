<%@ Page Language="VB" MasterPageFile="~/App_Presentation/MasterPage.master" AutoEventWireup="false"
    CodeFile="Beheer.aspx.vb" Inherits="App_Presentation_Beheer" Title="Untitled Page" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">

    <script type="text/javascript" src="JS/ckfinder/ckfinder.js"></script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div id="divLoggedIn" runat="server">
        <cc1:TabContainer runat="server" ID="TabBeheer" ActiveTabIndex="4">
            <cc1:TabPanel runat="server" HeaderText="Bedrijf" ID="tabBedrijf">
                <HeaderTemplate>
                    Bedrijf
            </HeaderTemplate>
                <ContentTemplate>
                    <asp:UpdatePanel ID="updBedrijf" runat="server">
                        <ContentTemplate>
                            <cc1:Accordion ID="AccordionBedrijf" runat="server" SelectedIndex="0" HeaderCssClass="art-BlockHeaderStrong"
                                ContentCssClass="art-content">
                                <Panes>
                                    <cc1:AccordionPane runat="server" BackColor="Black" ID="PaneBedrijfToevoegen">
                                        <Header>
                                            Bedrijf toevoegen</Header>
                                        <Content>
                                            <table>
                                                <tr>
                                                    <td class="lbl">
                                                        <asp:Label ID="lblBedrijfsnaam" runat="server" Text="Bedrijfsnaam: "></asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:TextBox ID="txtAddbedrijf" runat="server" Width="100%"></asp:TextBox><asp:RequiredFieldValidator
                                                            ID="vleAddBedrijf" runat="server" ErrorMessage="Gelieve een bedrijfsnaam in te geven."
                                                            ControlToValidate="txtAddbedrijf" Display="None" ValidationGroup="bedrijfToevoegen"></asp:RequiredFieldValidator><cc1:ValidatorCalloutExtender
                                                                ID="extAddBedrijf" runat="server" TargetControlID="vleAddBedrijf">
                                                            </cc1:ValidatorCalloutExtender>
                                                            <cc1:FilteredTextBoxExtender ID="fltbedrijfaddnaam" runat="server" FilterType="Custom, Numbers, UppercaseLetters, LowercaseLetters"
                                                            TargetControlID="txtAddbedrijf" ValidChars=". ">
                                                        </cc1:FilteredTextBoxExtender>
                                                    </td>
                                                    <td>
                                                        <span style="vertical-align: middle" id='tipAddBedrijf'>
                                                            <img src="CSS/images/help.png" alt='' /></span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="lbl">
                                                        <asp:Label ID="lblBedrijf" runat="server" Text="Tag: "></asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:TextBox ID="txtAddTag" runat="server" Width="100%"></asp:TextBox><asp:RequiredFieldValidator
                                                            ID="vleAddTag" runat="server" ErrorMessage="Gelieve een tag in te geven." ControlToValidate="txtAddTag"
                                                            Display="None" ValidationGroup="bedrijfToevoegen"></asp:RequiredFieldValidator><cc1:ValidatorCalloutExtender
                                                                ID="extAddTag" runat="server" TargetControlID="vleAddTag">
                                                            </cc1:ValidatorCalloutExtender>
                                                        <cc1:FilteredTextBoxExtender ID="fltAddTag" runat="server" FilterType="Custom, Numbers, UppercaseLetters, LowercaseLetters"
                                                            TargetControlID="txtAddTag" ValidChars="_">
                                                        </cc1:FilteredTextBoxExtender>
                                                    </td>
                                                    <td>
                                                        <span style="vertical-align: middle" id='tipAddTag'>
                                                            <img src="CSS/images/help.png" alt='' /></span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        &#160;&nbsp;
                                                    </td>
                                                    <td>
                                                        <asp:Button ID="btnAddBedrijf" runat="server" Text="Toevoegen" ValidationGroup="bedrijfToevoegen"
                                                            Width="100%" />
                                                    </td>
                                                    <td>
                                                        <asp:Image runat="server" ID="imgAddBedrijfRes" ImageUrl="~/App_Presentation/CSS/images/spacer.gif" />&nbsp;&nbsp;<asp:Label
                                                            ID="lblAddBedrijfRes" runat="server" Text=""></asp:Label>
                                                    </td>
                                                </tr>
                                            </table>
                                        </Content>
                                    </cc1:AccordionPane>
                                    <cc1:AccordionPane ID="PaneBedrijfWijzigen" runat="server">
                                        <Header>
                                            Bedrijf Wijzigen</Header>
                                        <Content>
                                            <table>
                                                <tr>
                                                    <td class="lbl">
                                                        <asp:Label ID="lblBewerkBedrijf" runat="server" Text="Kies een bedrijf: "></asp:Label>
                                                    </td>
                                                    <td class="ietd">
                                                        <asp:DropDownList ID="ddlBewerkBedrijf" runat="server" DataTextField="naam" DataValueField="bedrijfID"
                                                            OnSelectedIndexChanged="ddlBewerkBedrijf_SelectedIndexChanged" AutoPostBack="true"
                                                            Width="100%">
                                                        </asp:DropDownList>
                                                    </td>
                                                    <td>
                                                        <span style="vertical-align: middle" id='tipBewerkBedrijf'>
                                                            <img src="CSS/images/help.png" alt='' /></span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="lbl">
                                                        <asp:Label ID="lblEditBedrijf" runat="server" Text="Bedrijfsnaam: "></asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:TextBox ID="txtEditBedrijf" runat="server" Width="100%"></asp:TextBox><asp:RequiredFieldValidator
                                                            ID="vleEditBedrijf" runat="server" ErrorMessage="Gelieve een bedrijfsnaam in te geven."
                                                            ControlToValidate="txtEditBedrijf" Display="None" ValidationGroup="bedrijfWijzigen"></asp:RequiredFieldValidator><cc1:ValidatorCalloutExtender
                                                                ID="extEditBedrijf" runat="server" TargetControlID="vleEditBedrijf">
                                                            </cc1:ValidatorCalloutExtender>
                                                            <cc1:FilteredTextBoxExtender ID="ftlBedrijfEdit" runat="server" FilterType="Custom, Numbers, UppercaseLetters, LowercaseLetters"
                                                            TargetControlID="txtEditBedrijf" ValidChars=". ">
                                                        </cc1:FilteredTextBoxExtender>
                                                    </td>
                                                    <td>
                                                        <span style="vertical-align: middle" id='tipEditBedrijf'>
                                                            <img src="CSS/images/help.png" alt='' /></span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="lbl">
                                                        <asp:Label ID="lblEditTag" runat="server" Text="Tag: "></asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:TextBox ID="txtEditTag" runat="server" Width="100%"></asp:TextBox><asp:RequiredFieldValidator
                                                            ID="vleEditTag" runat="server" ErrorMessage="Gelieve een tag in te geven." ControlToValidate="txtEditTag"
                                                            Display="None" ValidationGroup="bedrijfWijzigen"></asp:RequiredFieldValidator><cc1:ValidatorCalloutExtender
                                                                ID="extEditTag" runat="server" TargetControlID="vleEditTag">
                                                            </cc1:ValidatorCalloutExtender>
                                                        <cc1:FilteredTextBoxExtender ID="fltEditTag" runat="server" FilterType="Custom, Numbers, UppercaseLetters, LowercaseLetters"
                                                            TargetControlID="txtEditTag" ValidChars=".">
                                                        </cc1:FilteredTextBoxExtender>
                                                    </td>
                                                    <td>
                                                        <span style="vertical-align: middle" id='tipEditTag'>
                                                            <img src="CSS/images/help.png" alt='' /></span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        &#160;&nbsp;
                                                    </td>
                                                    <td>
                                                        <asp:Button ID="btnEditBedrijf" runat="server" Text="Wijzigen" ValidationGroup="bedrijfWijzigen"
                                                            Width="100%" />
                                                    </td>
                                                    <td>
                                                        <asp:Image runat="server" ID="imgEditBedrijfRes" ImageUrl="~/App_Presentation/CSS/images/spacer.gif" />&nbsp;&nbsp;<asp:Label
                                                            ID="lblEditbedrijfRes" runat="server" Text=""></asp:Label>
                                                    </td>
                                                </tr>
                                            </table>
                                        </Content>
                                    </cc1:AccordionPane>
                                    <cc1:AccordionPane ID="PaneBedrijfVerwijderen" runat="server">
                                        <Header>
                                            Bedrijf verwijderen</Header>
                                        <Content>
                                            <table>
                                                <tr>
                                                    <td class="lbl">
                                                        <asp:Label ID="lblBedrijfNaamVerwijderen" runat="server" Text="Kies een bedrijf: "></asp:Label>
                                                    </td>
                                                    <td class="ietd">
                                                        <asp:DropDownList ID="ddlDeleteBedrijf" runat="server" DataTextField="naam" DataValueField="bedrijfID"
                                                            Width="100%">
                                                        </asp:DropDownList>
                                                    </td>
                                                    <td>
                                                        <span style="vertical-align: middle" id='tipDeleteBedrijf'>
                                                            <img src="CSS/images/help.png" alt='' /></span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                <td>
                                                Alle Artikels onder dit Bedrijf verwijderen: 
                                                </td>
                                                <td>
                                                    <asp:CheckBox ID="ckbAlleBedrijf" runat="server" />
                                                </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        &#160;&nbsp;
                                                    </td>
                                                    <td>
                                                        <asp:Button ID="btnDeleteBedrijf" runat="server" Text="Verwijderen" Width="100%" />
                                                    </td>
                                                    <td>
                                                        <asp:Image runat="server" ID="imgDeleteBedrijfRes" ImageUrl="~/App_Presentation/CSS/images/spacer.gif" />&nbsp;<asp:Label
                                                            ID="lblDeleteBedrijfRes" runat="server" Text=""></asp:Label>
                                                    </td>
                                                </tr>
                                            </table>
                                        </Content>
                                    </cc1:AccordionPane>
                                </Panes>
                            </cc1:Accordion>
                            <asp:UpdateProgress runat="server">
                                <ProgressTemplate>
                                    <div class="update">
                                        <img src="CSS/Images/ajaxloader.gif" />
                                        Even wachten aub...
                                    </div>
                                </ProgressTemplate>
                            </asp:UpdateProgress>
                        </ContentTemplate>
                    </asp:UpdatePanel>
            </ContentTemplate>
</cc1:TabPanel>
            <cc1:TabPanel runat="server" HeaderText="Taal" ID="tabTaal">
                <HeaderTemplate>
                    Taal
            </HeaderTemplate>
<ContentTemplate>
                    <asp:UpdatePanel ID="updTaal" runat="server">
                        <ContentTemplate>
                            <cc1:Accordion ID="AccordionTaal" runat="server" SelectedIndex="0" HeaderCssClass="art-BlockHeaderStrong"
                                ContentCssClass="art-content">
                                <Panes>
                                    <cc1:AccordionPane ID="PaneTaalToevoegen" runat="server" BackColor="Black">
                                        <Header>
                                            Taal toevoegen</Header>
                                        <Content>
                                            <table>
                                                <tr>
                                                    <td class="lbl">
                                                        <asp:Label ID="lblAddTaal" runat="server" Text="Taal: "></asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:TextBox ID="txtAddTaal" runat="server" Width="100%"></asp:TextBox><asp:RequiredFieldValidator
                                                            ID="vleAddTaal" runat="server" ErrorMessage="Gelieve een taal in te geven." ControlToValidate="txtAddTaal"
                                                            Display="None" ValidationGroup="taalToevoegen"></asp:RequiredFieldValidator><cc1:ValidatorCalloutExtender
                                                                ID="extAddTaal" runat="server" TargetControlID="vleAddTaal">
                                                            </cc1:ValidatorCalloutExtender>
                                                             <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender1" runat="server" FilterType="Custom, Numbers, UppercaseLetters, LowercaseLetters"
                                                            TargetControlID="txtAddTaal" ValidChars=".">
                                                        </cc1:FilteredTextBoxExtender>
                                                    </td>
                                                    <td>
                                                        <span style="vertical-align: middle" id='tipAddTaal'>
                                                            <img src="CSS/images/help.png" alt='' /></span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="lbl">
                                                        <asp:Label ID="lblAfkorting" runat="server" Text="Afkorting: "></asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:TextBox ID="txtTaalAfkorting" runat="server" Width="100%"></asp:TextBox><asp:RequiredFieldValidator
                                                            ID="vleTaalAfkorting" runat="server" ErrorMessage="Gelieve een afkorting in te geven."
                                                            ControlToValidate="txtTaalAfkorting" Display="None" ValidationGroup="taalToevoegen"></asp:RequiredFieldValidator>
                                                    <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender2" runat="server" FilterType="Custom, Numbers, UppercaseLetters, LowercaseLetters"
                                                            TargetControlID="txtTaalAfkorting" ValidChars=".">
                                                        </cc1:FilteredTextBoxExtender>
                                                    </td>
                                                    <td>
                                                        <span style="vertical-align: middle" id='tipTaalAfkorting'>
                                                            <img src="CSS/images/help.png" alt='' /></span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        &#160;&nbsp;
                                                    </td>
                                                    <td>
                                                        <asp:Button ID="btnAddTaal" runat="server" Text="Toevoegen" ValidationGroup="taalToevoegen"
                                                            Width="100%" />
                                                    </td>
                                                    <td>
                                                        <asp:Image runat="server" ID="imgAddTaalRes" ImageUrl="~/App_Presentation/CSS/images/spacer.gif" />&nbsp;<asp:Label
                                                            ID="lblAddTaalRes" runat="server" Text=""></asp:Label>
                                                    </td>
                                                </tr>
                                            </table>
                                        </Content>
                                    </cc1:AccordionPane>
                                    <cc1:AccordionPane ID="PaneTaalWijzigen" runat="server">
                                        <Header>
                                            Taal wijzigen</Header>
                                        <Content>
                                            <table>
                                                <tr>
                                                    <td class="lbl">
                                                        <asp:Label ID="lblBewerkTaal" runat="server" Text="Kies een taal: "></asp:Label>
                                                    </td>
                                                    <td class="ietd">
                                                        <asp:DropDownList ID="ddlBewerkTaal" runat="server" DataTextField="Taal" DataValueField="TaalID"
                                                            OnSelectedIndexChanged="ddlBewerkTaal_SelectedIndexChanged" AutoPostBack="true"
                                                            Width="100%">
                                                        </asp:DropDownList>
                                                    </td>
                                                    <td>
                                                        <span style="vertical-align: middle" id='tipBewerkTaal'>
                                                            <img src="CSS/images/help.png" alt='' /></span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="lbl">
                                                        <asp:Label ID="lblEditTaal" runat="server" Text="Taal: "></asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:TextBox ID="txtEditTaal" runat="server" Width="100%"></asp:TextBox><asp:RequiredFieldValidator
                                                            ID="vleEditTaal" runat="server" ErrorMessage="Gelieve een taal in te geven."
                                                            ControlToValidate="txtEditTaal" Display="None" ValidationGroup="taalWijzigen"></asp:RequiredFieldValidator><cc1:ValidatorCalloutExtender
                                                                ID="extEditTaal" runat="server" TargetControlID="vleEditTaal">
                                                            </cc1:ValidatorCalloutExtender>
                                                             <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender3" runat="server" FilterType="Custom, Numbers, UppercaseLetters, LowercaseLetters"
                                                            TargetControlID="txtEditTaal" ValidChars=".">
                                                        </cc1:FilteredTextBoxExtender>
                                                    </td>
                                                    <td>
                                                        <span style="vertical-align: middle" id='tipEditTaal'>
                                                            <img src="CSS/images/help.png" alt='' /></span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="lbl">
                                                        <asp:Label ID="lblEditAfkorting" runat="server" Text="Afkorting: "></asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:TextBox ID="txtEditAfkorting" runat="server" Width="100%"></asp:TextBox><asp:RequiredFieldValidator
                                                            ID="vleEditAfkorting" runat="server" ErrorMessage="Gelieve een afkorting in te geven."
                                                            ControlToValidate="txtEditAfkorting" Display="None" ValidationGroup="taalWijzigen"></asp:RequiredFieldValidator><cc1:ValidatorCalloutExtender
                                                                ID="extEditAfkorting" runat="server" TargetControlID="vleEditAfkorting">
                                                            </cc1:ValidatorCalloutExtender>
                                                             <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender4" runat="server" FilterType="Custom, Numbers, UppercaseLetters, LowercaseLetters"
                                                            TargetControlID="txtEditAfkorting" ValidChars=".">
                                                        </cc1:FilteredTextBoxExtender>
                                                    </td>
                                                    <td>
                                                        <span style="vertical-align: middle" id='tipEditAfkorting'>
                                                            <img src="CSS/images/help.png" alt='' /></span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <asp:Button ID="btnEditTaal" runat="server" Text="Wijzigen" ValidationGroup="taalWijzigen"
                                                            Width="100%" />
                                                    </td>
                                                    <td>
                                                        <asp:Image runat="server" ID="imgEditTaalRes" ImageUrl="~/App_Presentation/CSS/images/spacer.gif" />&nbsp;<asp:Label
                                                            ID="lblEditTaalRes" runat="server" Text=""></asp:Label>
                                                    </td>
                                                </tr>
                                            </table>
                                        </Content>
                                    </cc1:AccordionPane>
                                    <cc1:AccordionPane ID="PaneTaalVerwijderen" runat="server">
                                        <Header>
                                            Taal verwijderen</Header>
                                        <Content>
                                            <table>
                                                <tr>
                                                    <td class="lbl">
                                                        <asp:Label ID="lblTaalDelete" runat="server" Text="Kies een taal: "></asp:Label>
                                                    </td>
                                                    <td class="ietd">
                                                        <asp:DropDownList ID="ddlTaalDelete" runat="server" DataTextField="taal" DataValueField="TaalID"
                                                            Width="100%">
                                                        </asp:DropDownList>
                                                    </td>
                                                    <td>
                                                        <span style="vertical-align: middle" id='tipTaalDelete'>
                                                            <img src="CSS/images/help.png" alt='' /></span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        &#160;&nbsp;
                                                    </td>
                                                    <td>
                                                        <asp:Button ID="btnTaalDelete" runat="server" Text="Verwijderen" Width="100%" />
                                                    </td>
                                                    <td>
                                                        <asp:Image runat="server" ID="imgDeleteTaalRes" ImageUrl="~/App_Presentation/CSS/images/spacer.gif" />&nbsp;<asp:Label
                                                            ID="lblDeleteTaalRes" runat="server" Text=""></asp:Label>
                                                    </td>
                                                </tr>
                                            </table>
                                        </Content>
                                    </cc1:AccordionPane>
                                </Panes>
                            </cc1:Accordion>
                            <asp:UpdateProgress ID="UpdateProgress1" runat="server">
                                <ProgressTemplate>
                                    <div class="update">
                                        <img src="CSS/Images/ajaxloader.gif" />
                                        Even wachten aub...
                                    </div>
                                </ProgressTemplate>
                            </asp:UpdateProgress>
                        </ContentTemplate>
                    </asp:UpdatePanel>
            </ContentTemplate>
</cc1:TabPanel>
            <cc1:TabPanel runat="server" HeaderText="Versie" ID="tabVersie">
                <HeaderTemplate>
                    Versie
            </HeaderTemplate>
<ContentTemplate>
                    <asp:UpdatePanel ID="updVersie" runat="server">
                        <ContentTemplate>
                            <cc1:Accordion ID="AccordionVersie" runat="server" SelectedIndex="0" HeaderCssClass="art-BlockHeaderStrong"
                                ContentCssClass="art-content">
                                <Panes>
                                    <cc1:AccordionPane ID="PaneVersieToevoegen" runat="server" BackColor="Black">
                                        <Header>
                                            Versie toevoegen</Header>
                                        <Content>
                                            <table>
                                                <tr>
                                                    <td class="lbl">
                                                        <asp:Label ID="lblAddVersie" runat="server" Text="Versie: "></asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:TextBox ID="txtAddVersie" runat="server" Width="100%"></asp:TextBox><asp:RequiredFieldValidator
                                                            ID="vleAddVersie" runat="server" ErrorMessage="Gelieve een versienummer in te geven."
                                                            ControlToValidate="txtAddVersie" Display="None" ValidationGroup="versieToevoegen"></asp:RequiredFieldValidator><cc1:ValidatorCalloutExtender
                                                                ID="extAddVersie" runat="server" TargetControlID="vleAddVersie">
                                                            </cc1:ValidatorCalloutExtender>
                                                        <cc1:FilteredTextBoxExtender ID="fltAddVersie" runat="server" FilterType="Custom, Numbers"
                                                            TargetControlID="txtAddVersie" ValidChars=".">
                                                        </cc1:FilteredTextBoxExtender>
                                                    </td>
                                                    <td>
                                                        <span style="vertical-align: middle" id='tipAddVersie'>
                                                            <img src="CSS/images/help.png" alt='' /></span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        &#160;&nbsp;
                                                    </td>
                                                    <td>
                                                        <asp:Button ID="btnAddVersie" runat="server" Text="Toevoegen" ValidationGroup="versieToevoegen"
                                                            Width="100%" />
                                                    </td>
                                                    <td>
                                                        <asp:Image runat="server" ID="imgAddVersieRes" ImageUrl="~/App_Presentation/CSS/images/spacer.gif" />&nbsp;&nbsp;<asp:Label
                                                            ID="lblAddVersieRes" runat="server" Text=""></asp:Label>
                                                    </td>
                                                </tr>
                                            </table>
                                        </Content>
                                    </cc1:AccordionPane>
                                    <cc1:AccordionPane ID="PaneVersieWijzigen" runat="server">
                                        <Header>
                                            Versie wijzigen</Header>
                                        <Content>
                                            <table>
                                                <tr>
                                                    <td class="lbl">
                                                        <asp:Label ID="lblBewerkVersie" runat="server" Text="Kies een Versie: "></asp:Label>
                                                    </td>
                                                    <td class="ietd">
                                                        <asp:DropDownList ID="ddlBewerkVersie" runat="server" DataTextField="Versie" DataValueField="VersieID"
                                                            OnSelectedIndexChanged="ddlBewerkVersie_SelectedIndexChanged" AutoPostBack="true"
                                                            Width="100%">
                                                        </asp:DropDownList>
                                                    </td>
                                                    <td>
                                                        <span style="vertical-align: middle" id='tipBewerkVersie'>
                                                            <img src="CSS/images/help.png" alt='' /></span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="lbl">
                                                        <asp:Label ID="lblVersieWijzigen" runat="server" Text="Versie: "></asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:TextBox ID="txtEditVersie" runat="server" Width="100%"></asp:TextBox><asp:RequiredFieldValidator
                                                            ID="vleEditVersie" runat="server" ErrorMessage="Gelieve een versienummer in te geven."
                                                            ControlToValidate="txtEditVersie" Display="None" ValidationGroup="versieWijzigen"></asp:RequiredFieldValidator><cc1:ValidatorCalloutExtender
                                                                ID="extEditVersie" runat="server" TargetControlID="vleEditVersie">
                                                            </cc1:ValidatorCalloutExtender>
                                                        <cc1:FilteredTextBoxExtender ID="fltEditVersie" runat="server" FilterType="Custom, Numbers"
                                                            TargetControlID="txtEditVersie" ValidChars=".">
                                                        </cc1:FilteredTextBoxExtender>
                                                    </td>
                                                    <td>
                                                        <span style="vertical-align: middle" id='tipEditVersie'>
                                                            <img src="CSS/images/help.png" alt='' /></span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        &#160;&nbsp;
                                                    </td>
                                                    <td>
                                                        <asp:Button ID="btnEditVersie" runat="server" Text="Wijzigen" ValidationGroup="versieWijzigen"
                                                            Width="100%" />
                                                    </td>
                                                    <td>
                                                        <asp:Image runat="server" ID="imgEditVersieRes" ImageUrl="~/App_Presentation/CSS/images/spacer.gif" />&nbsp;&nbsp;<asp:Label
                                                            ID="lblEditVersieRes" runat="server" Text=""></asp:Label>
                                                    </td>
                                                </tr>
                                            </table>
                                        </Content>
                                    </cc1:AccordionPane>
                                    <cc1:AccordionPane ID="PaneVersieKopieren" runat="server">
                                        <Header>
                                            Versie kopiëren</Header>
                                        <Content>
                                            <table>
                                                <tr>
                                                    <td class="lbl">
                                                        <asp:Label ID="lblVersiekopieren" runat="server" Text="Kies een versie om te kopiëren: "></asp:Label>
                                                    </td>
                                                    <td class="ietd">
                                                        <asp:DropDownList ID="ddlVersiekopieren" runat="server" DataTextField="Versie" DataValueField="VersieID"
                                                            AutoPostBack="true" Width="100%">
                                                        </asp:DropDownList>
                                                    </td>
                                                    <td>
                                                        <span style="vertical-align: middle" id='tipVersieKopieren'>
                                                            <img src="CSS/images/help.png" alt='' /></span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        &#160;&nbsp;
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <th align="left">
                                                        Kopieergegevens
                                                    </th>
                                                </tr>
                                                <tr>
                                                    <td class="lbl">
                                                        <asp:Label ID="lblKopieVersieAantalCategorien" runat="server" Text="Aantal categorieën: "></asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:Label ID="lblKopieVersieAantalCat" runat="server"></asp:Label>
                                                    </td>
                                                    <td>
                                                        <span style="vertical-align: middle" id='tipAantalCategorien'>
                                                            <img src="CSS/images/help.png" alt='' /></span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="lbl">
                                                        <asp:Label ID="lblKopieVersieAantalArtikels" runat="server" Text="Aantal artikels: "></asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:Label ID="lblKopieVersieAantalArt" runat="server"></asp:Label>
                                                    </td>
                                                    <td>
                                                        <span style="vertical-align: middle" id='tipAantalArtikels'>
                                                            <img src="CSS/images/help.png" alt='' /></span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="lbl">
                                                        <asp:Label ID="lblNaamNieuweVersieKopie" runat="server" Text="Naam van de nieuwe versie: "></asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:TextBox ID="txtNaamNieuweVersieKopie" runat="server" Width="100%"></asp:TextBox><asp:RequiredFieldValidator
                                                            ID="vleNaamNieuweVersieKopie" runat="server" ErrorMessage="Gelieve een versienummer in te geven."
                                                            ControlToValidate="txtNaamNieuweVersieKopie" Display="None" ValidationGroup="versieKopieren"></asp:RequiredFieldValidator><cc1:ValidatorCalloutExtender
                                                                ID="extNaamNieuweVersieKopie" runat="server" TargetControlID="vleNaamNieuweVersieKopie">
                                                            </cc1:ValidatorCalloutExtender>
                                                        <cc1:FilteredTextBoxExtender ID="fltNaamNieuweVersieKopie" runat="server" FilterType="Custom, Numbers"
                                                            TargetControlID="txtNaamNieuweVersieKopie" ValidChars=".">
                                                        </cc1:FilteredTextBoxExtender>
                                                    </td>
                                                    <td>
                                                        <span style="vertical-align: middle" id='tipNaamVersieKopie'>
                                                            <img src="CSS/images/help.png" alt='' /></span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        &#160;&nbsp;
                                                    </td>
                                                    <td>
                                                        <asp:Button ID="btnVersieKopieren" runat="server" Text="Kopiëren" ValidationGroup="versieKopieren"
                                                            Width="100%" />
                                                    </td>
                                                    <td>
                                                        <asp:Image runat="server" ID="imgVersieKopierenFeedback" ImageUrl="~/App_Presentation/CSS/images/spacer.gif" />&nbsp;<asp:Label
                                                            ID="lblVersieKopierenFeedback" runat="server" Text=""></asp:Label>
                                                    </td>
                                                </tr>
                                            </table>
                                        </Content>
                                    </cc1:AccordionPane>
                                    <cc1:AccordionPane ID="PaneVersieVerwijderen" runat="server">
                                        <Header>
                                            Versie verwijderen</Header>
                                        <Content>
                                            <table>
                                                <tr>
                                                    <td class="lbl">
                                                        <asp:Label ID="lblVerwijderVersie" runat="server" Text="Versie: "></asp:Label>
                                                    </td>
                                                    <td class="ietd">
                                                        <asp:DropDownList ID="ddlDeletVersie" runat="server" DataTextField="versie" DataValueField="versieID"
                                                            Width="100%">
                                                        </asp:DropDownList>
                                                    </td>
                                                    <td>
                                                        <span style="vertical-align: middle" id='tipDeleteVersie'>
                                                            <img src="CSS/images/help.png" alt='' /></span>
                                                    </td>
                                                </tr>
                                                
                                                <tr>
                                                
                                                <td>Alle Artikels en Categoriën onder deze versie ook verwijderen: </td>
                                                <td>
                                                    <asp:CheckBox ID="ckbAllesOnderVersie" runat="server" /></td>
                                                </tr>
                                                
                                                
                                                <tr>
                                                    <td>
                                                        &#160;&nbsp;
                                                    </td>
                                                    <td>
                                                        <asp:Button ID="btnDeleteVersie" runat="server" Text="Verwijderen" Width="100%" />
                                                    </td>
                                                    <td>
                                                        <asp:Image runat="server" ID="imgDeleteVersieRes" ImageUrl="~/App_Presentation/CSS/images/spacer.gif" />&nbsp;<asp:Label
                                                            ID="lblDeleteVersieRes" runat="server" Text=""></asp:Label>
                                                    </td>
                                                </tr>
                                            </table>
                                        </Content>
                                    </cc1:AccordionPane>
                                </Panes>
                            </cc1:Accordion>
                            <asp:UpdateProgress ID="UpdateProgress2" runat="server">
                                <ProgressTemplate>
                                    <div class="update">
                                        <img src="CSS/Images/ajaxloader.gif" />
                                        Even wachten aub...
                                    </div>
                                </ProgressTemplate>
                            </asp:UpdateProgress>
                        </ContentTemplate>
                    </asp:UpdatePanel>
            </ContentTemplate>
</cc1:TabPanel>
<cc1:TabPanel runat="server" HeaderText="Taal" ID="tabModule">
                <HeaderTemplate>
                    Module
            </HeaderTemplate>
<ContentTemplate>
                    <asp:UpdatePanel ID="updModule" runat="server">
                        <ContentTemplate>
                            <cc1:Accordion ID="accordionModule" runat="server" SelectedIndex="0" HeaderCssClass="art-BlockHeaderStrong"
                                ContentCssClass="art-content">
                                <Panes>
                                    <cc1:AccordionPane ID="paneModuleToevoegen" runat="server" BackColor="Black">
                                        <Header>
                                            Module toevoegen</Header>
                                        <Content>
                                            <table>
                                                <tr>
                                                    <td class="lbl">
                                                        <asp:Label ID="lblModuleToevoegenNaam" runat="server" Text="Naam: "></asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:TextBox ID="txtModuleToevoegenNaam" runat="server" Width="200"></asp:TextBox><asp:RequiredFieldValidator
                                                            ID="vleModuleToevoegenNaam" runat="server" ErrorMessage="Gelieve een naam in te geven." ControlToValidate="txtModuleToevoegenNaam"
                                                            Display="None" ValidationGroup="moduleToevoegen"></asp:RequiredFieldValidator><cc1:ValidatorCalloutExtender
                                                                ID="extModuleToevoegenNaam" runat="server" TargetControlID="vleModuleToevoegenNaam">
                                                            </cc1:ValidatorCalloutExtender>
                                                             <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender5" runat="server" FilterType="Custom, Numbers, UppercaseLetters, LowercaseLetters"
                                                            TargetControlID="txtModuleToevoegenNaam" ValidChars=".">
                                                        </cc1:FilteredTextBoxExtender>
                                                    </td>
                                                    <td>
                                                        <span style="vertical-align: middle" id='tipModuleToevoegenNaam'>
                                                            <img src="CSS/images/help.png" alt='' /></span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        &#160;&nbsp;
                                                    </td>
                                                    <td>
                                                        <asp:Button ID="btnModuleToevoegen" runat="server" Text="Toevoegen" ValidationGroup="moduleToevoegen"
                                                            Width="200" />
                                                    </td>
                                                    <td>
                                                        <asp:Image runat="server" ID="imgModuleToevoegenRes" ImageUrl="~/App_Presentation/CSS/images/spacer.gif" />&nbsp;<asp:Label
                                                            ID="lblModuleToevoegenRes" runat="server" Text=""></asp:Label>
                                                    </td>
                                                </tr>
                                            </table>
                                        </Content>
                                    </cc1:AccordionPane>
                                    <cc1:AccordionPane ID="paneModuleWijzigen" runat="server">
                                        <Header>
                                            Module wijzigen</Header>
                                        <Content>
                                            <table>
                                                <tr>
                                                    <td class="lbl">
                                                        <asp:Label ID="lblModuleWijzigenKeuze" runat="server" Text="Kies een module: "></asp:Label>
                                                    </td>
                                                    <td class="ietd">
                                                        <asp:DropDownList ID="ddlModuleWijzigenKeuze" runat="server" DataTextField="module" DataValueField="moduleID" AutoPostBack="true"
                                                            Width="100%">
                                                        </asp:DropDownList>
                                                    </td>
                                                    <td>
                                                        <span style="vertical-align: middle" id='tipModuleWijzigenKeuze'>
                                                            <img src="CSS/images/help.png" alt='' /></span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="lbl">
                                                        <asp:Label ID="lblModuleWijzigenNaam" runat="server" Text="Naam: "></asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:TextBox ID="txtModuleWijzigenNaam" runat="server" Width="100%"></asp:TextBox><asp:RequiredFieldValidator
                                                            ID="vleModuleWijzigenNaam" runat="server" ErrorMessage="Gelieve een naam in te geven."
                                                            ControlToValidate="txtModuleWijzigenNaam" Display="None" ValidationGroup="moduleWijzigen"></asp:RequiredFieldValidator><cc1:ValidatorCalloutExtender
                                                                ID="extModuleWijzigenNaam" runat="server" TargetControlID="vleModuleWijzigenNaam">
                                                            </cc1:ValidatorCalloutExtender>
                                                             <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender6" runat="server" FilterType="Custom, Numbers, UppercaseLetters, LowercaseLetters"
                                                            TargetControlID="txtModuleWijzigenNaam" ValidChars=".">
                                                        </cc1:FilteredTextBoxExtender>
                                                    </td>
                                                    <td>
                                                        <span style="vertical-align: middle" id='tipModuleWijzigenNaam'>
                                                            <img src="CSS/images/help.png" alt='' /></span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                    &nbsp;
                                                    </td>
                                                    <td>
                                                        <asp:Button ID="btnModuleWijzigen" runat="server" Text="Wijzigen" ValidationGroup="moduleWijzigen"
                                                            Width="100%" />
                                                    </td>
                                                    <td>
                                                        <asp:Image runat="server" ID="imgModuleWijzigenRes" ImageUrl="~/App_Presentation/CSS/images/spacer.gif" />&nbsp;<asp:Label
                                                            ID="lblModuleWijzigenRes" runat="server" Text=""></asp:Label>
                                                    </td>
                                                </tr>
                                            </table>
                                        </Content>
                                    </cc1:AccordionPane>
                                    <cc1:AccordionPane ID="paneModuleVerwijderen" runat="server">
                                        <Header>
                                            Module verwijderen</Header>
                                        <Content>
                                            <table>
                                                <tr>
                                                    <td class="lbl">
                                                        <asp:Label ID="lblModuleVerwijderenKeuze" runat="server" Text="Kies een module: "></asp:Label>
                                                    </td>
                                                    <td class="ietd">
                                                        <asp:DropDownList ID="ddlModuleVerwijderenKeuze" runat="server" DataTextField="taal" DataValueField="TaalID"
                                                            Width="100%">
                                                        </asp:DropDownList>
                                                    </td>
                                                    <td>
                                                        <span style="vertical-align: middle" id='tipModuleVerwijderenKeuze'>
                                                            <img src="CSS/images/help.png" alt='' /></span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        &#160;&nbsp;
                                                    </td>
                                                    <td>
                                                        <asp:Button ID="btnModuleVerwijderen" runat="server" Text="Verwijderen" Width="100%" />
                                                    </td>
                                                    <td>
                                                        <asp:Image runat="server" ID="imgModuleVerwijderenRes" ImageUrl="~/App_Presentation/CSS/images/spacer.gif" />&nbsp;<asp:Label
                                                            ID="lblModuleVerwijderenRes" runat="server" Text=""></asp:Label>
                                                    </td>
                                                </tr>
                                            </table>
                                        </Content>
                                    </cc1:AccordionPane>
                                </Panes>
                            </cc1:Accordion>
                            <asp:UpdateProgress ID="UpdateProgress6" runat="server">
                                <ProgressTemplate>
                                    <div class="update">
                                        <img src="CSS/Images/ajaxloader.gif" />
                                        Even wachten aub...
                                    </div>
                                </ProgressTemplate>
                            </asp:UpdateProgress>
                        </ContentTemplate>
                    </asp:UpdatePanel>
            </ContentTemplate>
</cc1:TabPanel>
            <cc1:TabPanel runat="server" HeaderText="Categorie" ID="TabCategorie">
                <HeaderTemplate>
                    Categorie
            </HeaderTemplate>
<ContentTemplate>
                    <asp:UpdatePanel ID="updCategorie" runat="server"><ContentTemplate>
                            <cc1:Accordion ID="AccordionCategorie" runat="server" SelectedIndex="0" HeaderCssClass="art-BlockHeaderStrong"
                                ContentCssClass="art-content">
                                <Panes>
                                    <cc1:AccordionPane ID="PaneCategorieToevoegen" runat="server" BackColor="Black">
                                        <Header>
                                            Categorie toevoegen</Header>
                                        <Content>
                                            <table>
                                                <tr>
                                                    <th align="left">
                                                        Categorie toevoegen
                                                    </th>
                                                </tr>
                                                <tr>
                                                    <td class="lbl">
                                                        <asp:Label ID="lblAddCatnaam" runat="server" Text="Categorienaam: "></asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:TextBox ID="txtAddCatnaam" runat="server" Width="100%"></asp:TextBox><asp:RequiredFieldValidator
                                                            ID="vleAddCatnaam" runat="server" ErrorMessage="Gelieve een categorienaam in te geven."
                                                            ControlToValidate="txtAddCatnaam" Display="None" ValidationGroup="categorieToevoegen"></asp:RequiredFieldValidator><cc1:ValidatorCalloutExtender
                                                                ID="extAddCatnaam" runat="server" TargetControlID="vleAddCatnaam">
                                                            </cc1:ValidatorCalloutExtender>
                                                    </td>
                                                    <td>
                                                        <span style="vertical-align: middle" id='tipAddCatnaam'>
                                                            <img src="CSS/images/help.png" alt='' /></span>
                                                    </td>
                                                </tr>
                                                <tr style="display:none">
                                                    <td class="lbl">
                                                        <asp:Label ID="lblAddHoogte" runat="server" Text="Kies een hoogte: "></asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:TextBox ID="txtAddhoogte" runat="server" Width="100%"></asp:TextBox><asp:RequiredFieldValidator
                                                            ID="vleAddhoogte" runat="server" ErrorMessage="Gelieve een geldige hoogte in te geven."
                                                            ControlToValidate="txtAddhoogte" Display="None" ValidationGroup="categorieToevoegen"></asp:RequiredFieldValidator><cc1:ValidatorCalloutExtender
                                                                ID="extAddhoogte" runat="server" TargetControlID="vleAddhoogte">
                                                            </cc1:ValidatorCalloutExtender>
                                                        <cc1:FilteredTextBoxExtender ID="fltAddhoogte" runat="server" FilterType="Numbers"
                                                            TargetControlID="txtAddhoogte">
                                                        </cc1:FilteredTextBoxExtender>
                                                    </td>
                                                    <td>
                                                        <span style="vertical-align: middle" id='tipAddhoogte'>
                                                            <img src="CSS/images/help.png" alt='' /></span>&#160;
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="lbl">
                                                        <asp:Label ID="lblAddCatVersie" runat="server" Text="Kies een versie: "></asp:Label>
                                                    </td>
                                                    <td class="ietd">
                                                        <asp:DropDownList ID="ddlAddCatVersie" runat="server" DataTextField="Versie" DataValueField="VersieID"
                                                            AutoPostBack="true" Width="100%">
                                                        </asp:DropDownList>
                                                    </td>
                                                    <td>
                                                        <span style="vertical-align: middle" id='tipAddCatVersie'>
                                                            <img src="CSS/images/help.png" alt='' /></span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="lbl">
                                                        <asp:Label ID="lblAddCatTaal" runat="server" Text="Kies een taal: "></asp:Label>
                                                    </td>
                                                    <td class="ietd">
                                                        <asp:DropDownList ID="ddlAddCatTaal" runat="server" DataTextField="Taal" DataValueField="TaalID"
                                                            AutoPostBack="true" Width="100%">
                                                        </asp:DropDownList>
                                                    </td>
                                                    <td>
                                                        <span style="vertical-align: middle" id='tipAddCatTaal'>
                                                            <img src="CSS/images/help.png" alt='' /></span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="lbl">
                                                        <asp:Label ID="lblAddCatBedrijf" runat="server" Text="Kies een bedrijf: "></asp:Label>
                                                    </td>
                                                    <td class="ietd">
                                                        <asp:DropDownList ID="ddlAddCatBedrijf" runat="server" DataTextField="naam" DataValueField="bedrijfID"
                                                            AutoPostBack="true" Width="100%">
                                                        </asp:DropDownList>
                                                    </td>
                                                    <td>
                                                        <span style="vertical-align: middle" id='tipAddCatBedrijf'>
                                                            <img src="CSS/images/help.png" alt='' /></span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="lbl">
                                                        <asp:Label ID="lblAddParentCat" runat="server" Text="Kies een hoofdcategorie: "></asp:Label>
                                                    </td>
                                                    <td class="ietd">
                                                        <asp:DropDownList ID="ddlAddParentcat" runat="server" DataTextField="Categorie" DataValueField="CategorieID"
                                                            OnSelectedIndexChanged="ddlAddParentcat_SelectedIndexChanged" AutoPostBack="True"
                                                            Width="100%">
                                                        </asp:DropDownList>
                                                    </td>
                                                    <td>
                                                        <span style="vertical-align: middle" id='tipAddParentcat'>
                                                            <img src="CSS/images/help.png" alt='' /></span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        &#160;&#160;
                                                    </td>
                                                    <td>
                                                        <asp:Button ID="btnCatAdd" runat="server" Text="Toevoegen" ValidationGroup="categorieToevoegen"
                                                            Width="100%"></asp:Button>
                                                    </td>
                                                    <td>
                                                        <asp:Image runat="server" ID="imgResAdd" ImageUrl="~/App_Presentation/CSS/images/spacer.gif" />&nbsp;<asp:Label
                                                            ID="lblResAdd" runat="server" Text=""></asp:Label>
                                                    </td>
                                                </tr>
                                            </table>
                                        </Content>
                                    </cc1:AccordionPane>
                                    <cc1:AccordionPane ID="PaneCategorieWijzigen" runat="server">
                                        <Header>
                                            Categorie wijzigen</Header>
                                        <Content>
                                            <table>
                                                <tr>
                                                    <th align="left">
                                                        Categoriekeuze verfijnen
                                                    </th>
                                                </tr>
                                                <tr>
                                                    <td class="lbl">
                                                        <asp:Label ID="lblBewerkCatVersiekeuze" runat="server" Text="Filter op versie: "></asp:Label>
                                                    </td>
                                                    <td class="ietd">
                                                        <asp:DropDownList ID="ddlEditCatVersiekeuze" runat="server" DataTextField="Versie"
                                                            DataValueField="VersieID" Width="100%">
                                                        </asp:DropDownList>
                                                    </td>
                                                    <td>
                                                        <span style="vertical-align: middle" id='tipEditCatVersiekeuze'>
                                                            <img src="CSS/images/help.png" alt='' /></span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="lbl">
                                                        <asp:Label ID="lblBewerkCatTaalkeuze" runat="server" Text="Filter op taal: "></asp:Label>
                                                    </td>
                                                    <td class="ietd">
                                                        <asp:DropDownList ID="ddlEditCatTaalkeuze" runat="server" DataTextField="Taal" DataValueField="TaalID"
                                                            Width="100%">
                                                        </asp:DropDownList>
                                                    </td>
                                                    <td>
                                                        <span style="vertical-align: middle" id='tipEditCatTaalkeuze'>
                                                            <img src="CSS/images/help.png" alt='' /></span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="lbl">
                                                        <asp:Label ID="lblBewerkCatBedrijfkeuze" runat="server" Text="Filter op bedrijf: "></asp:Label>
                                                    </td>
                                                    <td class="ietd">
                                                        <asp:DropDownList ID="ddlEditCatBedrijfkeuze" runat="server" DataTextField="naam"
                                                            DataValueField="bedrijfID" Width="100%">
                                                        </asp:DropDownList>
                                                    </td>
                                                    <td>
                                                        <span style="vertical-align: middle" id='tipEditCatBedrijfkeuze'>
                                                            <img src="CSS/images/help.png" alt='' /></span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="lbl">
                                                        &#160;&#160;
                                                    </td>
                                                    <td>
                                                        <asp:Button ID="btnEditCatVerfijnen" runat="server" Text="Filteren" Width="100%">
                                                        </asp:Button>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        &#160;&#160;
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <th align="left">
                                                        Categorie wijzigen
                                                    </th>
                                                </tr>
                                                <tr>
                                                    <td class="lbl">
                                                        <asp:Label ID="lblBewerkCategorie" runat="server" Text="Kies een categorie: "></asp:Label>
                                                    </td>
                                                    <td class="ietd">
                                                        <div runat="server" id="divEditCategorie">
                                                            <asp:DropDownList ID="ddlEditCategorie" DataTextField="Categorie" DataValueField="CategorieID"
                                                                runat="server" OnSelectedIndexChanged="ddlEditCategorie_SelectedIndexChanged"
                                                                AutoPostBack="true" Width="100%">
                                                            </asp:DropDownList>
                                                        </div>
                                                        <asp:Label runat="server" ID="ddlEditCategorieGeenCats" Text="Er zijn geen categorieën beschikbaar."
                                                            style="display:none;"></asp:Label>
                                                    </td>
                                                    <td>
                                                        <span style="vertical-align: middle" id='tipEditCategorie'>
                                                            <img src="CSS/images/help.png" alt='' /></span>
                                                    </td>
                                                </tr>
                                                <tr runat="server" id="trCatBewerkNaam">
                                                    <td class="lbl">
                                                        <asp:Label ID="lblCatBewerkNaam" runat="server" Text="Categorienaam: "></asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:TextBox ID="txtCatbewerknaam" runat="server" Width="100%"></asp:TextBox><asp:RequiredFieldValidator
                                                            ID="vleCatbewerknaam" runat="server" ErrorMessage="Gelieve een categorienaam in te geven."
                                                            ControlToValidate="txtCatbewerknaam" Display="None" ValidationGroup="categorieWijzigen"></asp:RequiredFieldValidator><cc1:ValidatorCalloutExtender
                                                                ID="extCatbewerknaam" runat="server" TargetControlID="vleCatbewerknaam">
                                                            </cc1:ValidatorCalloutExtender>
                                                    </td>
                                                    <td>
                                                        <span style="vertical-align: middle" id='tipCatbewerknaam'>
                                                            <img src="CSS/images/help.png" alt='' /></span>
                                                    </td>
                                                </tr>
                                                <tr runat="server" id="trBewerkCatHoogte" style="display:none">
                                                    <td class="lbl">
                                                        <asp:Label ID="lblBewerkHCatoogte" runat="server" Text="Kies een hoogte: "></asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:TextBox ID="txtEditCathoogte" runat="server" Width="100%"></asp:TextBox><asp:RequiredFieldValidator
                                                            ID="vleEditCathoogte" runat="server" ErrorMessage="Gelieve een geldige hoogte in te geven."
                                                            ControlToValidate="txtEditCathoogte" Display="None" ValidationGroup="categorieWijzigen"></asp:RequiredFieldValidator><cc1:ValidatorCalloutExtender
                                                                ID="extEditCathoogte" runat="server" TargetControlID="vleEditCathoogte">
                                                            </cc1:ValidatorCalloutExtender>
                                                    </td>
                                                    <td>
                                                        <span style="vertical-align: middle" id='tipEditCatHoogte'>
                                                            <img src="CSS/images/help.png" alt='' /></span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        &#160;&#160;
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <th align="left">
                                                        Categorie verplaatsen
                                                    </th>
                                                </tr>
                                                <tr runat="server" id="trBewerkCatVersie">
                                                    <td class="lbl">
                                                        <asp:Label ID="lblBewerkCatVersie" runat="server" Text="Kies een versie: "></asp:Label>
                                                    </td>
                                                    <td class="ietd">
                                                        <asp:DropDownList ID="ddlEditCatVersie" runat="server" DataTextField="Versie" DataValueField="VersieID"
                                                            AutoPostBack="true" Width="100%">
                                                        </asp:DropDownList>
                                                    </td>
                                                    <td>
                                                        <span style="vertical-align: middle" id='tipEditCatVersie'>
                                                            <img src="CSS/images/help.png" alt='' /></span>
                                                    </td>
                                                </tr>
                                                <tr runat="server" id="trBewerkCatTaal">
                                                    <td class="lbl">
                                                        <asp:Label ID="lblBewerkCatTaal" runat="server" Text="Kies een taal: "></asp:Label>
                                                    </td>
                                                    <td class="ietd">
                                                        <asp:DropDownList ID="ddlEditCatTaal" runat="server" DataTextField="Taal" DataValueField="TaalID"
                                                            AutoPostBack="true" Width="100%">
                                                        </asp:DropDownList>
                                                    </td>
                                                    <td>
                                                        <span style="vertical-align: middle" id='tipEditCatTaal'>
                                                            <img src="CSS/images/help.png" alt='' /></span>
                                                    </td>
                                                </tr>
                                                <tr runat="server" id="trBewerkCatBedrijf">
                                                    <td class="lbl">
                                                        <asp:Label ID="lblBewerkCatBedrijf" runat="server" Text="Kies een bedrijf: "></asp:Label>
                                                    </td>
                                                    <td class="ietd">
                                                        <asp:DropDownList ID="ddlEditCatBedrijf" runat="server" DataTextField="naam" DataValueField="bedrijfID"
                                                            AutoPostBack="true" Width="100%">
                                                        </asp:DropDownList>
                                                    </td>
                                                    <td>
                                                        <span style="vertical-align: middle" id='tipEditCatBedrijf'>
                                                            <img src="CSS/images/help.png" alt='' /></span>
                                                    </td>
                                                </tr>
                                                <tr runat="server" id="trBewerkParentCat">
                                                    <td class="lbl">
                                                        <asp:Label ID="lblBewerkParentCat" runat="server" Text="Kies een hoofdcategorie: "></asp:Label>
                                                    </td>
                                                    <td class="ietd">
                                                        <asp:DropDownList ID="ddlEditCatParent" runat="server" DataTextField="Categorie"
                                                            DataValueField="CategorieID" OnSelectedIndexChanged="ddlEditCatParent_SelectedIndexChanged"
                                                            AutoPostBack="true" Width="100%">
                                                        </asp:DropDownList>
                                                    </td>
                                                    <td>
                                                        <span style="vertical-align: middle" id='tipEditCatParent'>
                                                            <img src="CSS/images/help.png" alt='' /></span>
                                                    </td>
                                                </tr>
                                                <tr runat="server" id="trCatEditButton">
                                                    <td>
                                                        &#160;&#160;
                                                    </td>
                                                    <td>
                                                        <asp:Button ID="btnCatEdit" runat="server" Text="Wijzigen" ValidationGroup="categorieWijzigen"
                                                            Width="100%"></asp:Button>
                                                    </td>
                                                    <td>
                                                        <asp:Image runat="server" ID="imgResEdit" ImageUrl="~/App_Presentation/CSS/images/spacer.gif" />&nbsp;<asp:Label
                                                            ID="lblResEdit" runat="server" Text=""></asp:Label>
                                                    </td>
                                                </tr>
                                            </table>
                                        </Content>
                                    </cc1:AccordionPane>
                                    <cc1:AccordionPane runat="server" ID="PaneCategoriePositioneren">
                                    <Header>Categorie Positioneren</Header>
                                    <Content>
                                    <asp:SqlDataSource ID="sqlReOrderList" runat="server" 
                                ConnectionString="<%$ ConnectionStrings:Reference_manualConnectionString %>" 
                                SelectCommand="Manual_getCategorieByParentVersieTaalBedrijf" 
                                SelectCommandType="StoredProcedure"
                                UpdateCommand="UPDATE tblCategorie SET Hoogte = @Hoogte WHERE CategorieID = @CategorieID">
                                <SelectParameters>
                                    <asp:ControlParameter ControlID="ddlCatPositieCategorie" Name="FK_Parent" 
                                        PropertyName="SelectedValue" Type="Int32" />
                                    <asp:ControlParameter ControlID="ddlCatPositieTaal" Name="FK_Taal" 
                                        PropertyName="SelectedValue" Type="Int32" />
                                    <asp:ControlParameter ControlID="ddlCatPositieVersie" Name="FK_Versie" 
                                        PropertyName="SelectedValue" Type="Int32" />
                                    <asp:ControlParameter ControlID="ddlCatPositieBedrijf" Name="FK_Bedrijf" 
                                        PropertyName="SelectedValue" Type="Int32" />
                                </SelectParameters>
                                <UpdateParameters>
                                    <asp:Parameter Name="@Hoogte" />
                                    <asp:Parameter Name="@CategorieID" />
                                </UpdateParameters>
                            </asp:SqlDataSource>
                                    <table>
                                                <tr>
                                                    <th align="left">
                                                        Categoriekeuze verfijnen
                                                    </th>
                                                </tr>
                                                <tr>
                                                    <td class="lbl">
                                                        <asp:Label ID="lblCatPositieVersie" runat="server" Text="Filter op versie: "></asp:Label>
                                                    </td>
                                                    <td class="ietd">
                                                        <asp:DropDownList ID="ddlCatPositieVersie" runat="server" DataTextField="Versie"
                                                            DataValueField="VersieID" Width="100%">
                                                        </asp:DropDownList>
                                                    </td>
                                                    <td>
                                                        <span style="vertical-align: middle" id='tipCatPositieVersie'>
                                                            <img src="CSS/images/help.png" alt='' /></span>&#160;
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="lbl">
                                                        <asp:Label ID="lblCatPositieTaal" runat="server" Text="Filter op taal: "></asp:Label>
                                                    </td>
                                                    <td class="ietd">
                                                        <asp:DropDownList ID="ddlCatPositieTaal" runat="server" DataTextField="Taal" DataValueField="TaalID"
                                                            Width="100%">
                                                        </asp:DropDownList>
                                                    </td>
                                                    <td>
                                                        <span style="vertical-align: middle" id='tipCatPositieTaal'>
                                                            <img src="CSS/images/help.png" alt='' /></span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="lbl">
                                                        <asp:Label ID="lblCatPositieBedrijf" runat="server" Text="Filter op bedrijf: "></asp:Label>
                                                    </td>
                                                    <td class="ietd">
                                                        <asp:DropDownList ID="ddlCatPositieBedrijf" runat="server" DataTextField="naam"
                                                            DataValueField="bedrijfID" Width="100%">
                                                        </asp:DropDownList>
                                                    </td>
                                                    <td>
                                                        <span style="vertical-align: middle" id='tipCatPositieBedrijf'>
                                                            <img src="CSS/images/help.png" alt='' /></span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="lbl">
                                                        &#160;&#160;
                                                    </td>
                                                    <td>
                                                        <asp:Button ID="btnCatPositieFilteren" runat="server" Text="Filteren" Width="100%" UseSubmitBehavior="false" /></asp:Button>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="lbl">
                                                        <asp:Label ID="lblCatPositieCategorie" runat="server" Text="Categorie: "></asp:Label>
                                                    </td>
                                                    <td class="ietd">
                                                        <asp:DropDownList ID="ddlCatPositieCategorie" runat="server" DataTextField="categorie"
                                                            DataValueField="categorieID" Width="100%" AutoPostBack="true">
                                                        </asp:DropDownList>
                                                    </td>
                                                    <td>
                                                        <span style="vertical-align: middle" id='tipCatPositieCategorie'>
                                                            <img src="CSS/images/help.png" alt='' /></span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        &#160;&#160;
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <th align="left">
                                                        Categorie Positioneren
                                                    </th>
                                                </tr>
                                                <tr>
                                                    <td colspan="2">
                                                        Gebruik de icoontjes aan de linkerzijde om een categorie te positioneren.<br />
                                                        Gelieve enkele seconden te wachten na elke verplaatsing om de gegevens te laten updaten.<br />
                                                        <strong>OPMERKING: </strong> De boomstructuur in de linkerzijde wordt slechts geüpdatet nadat de pagina is herladen.<br />
                                                        Om de dropdownlijst hierboven te updaten klikt u terug op de filterknop.
                                                        <div class="reorderlist">
                                                        <cc1:ReorderList OnItemReorder="PostioneerCategorieInCode" ID="ReOrderCategorie" runat="server" DataSourceID="sqlReOrderList" DataKeyField="CategorieID" SortOrderField="Hoogte" AllowReorder="true" >
                                                        <ItemTemplate><div class="reorderitem"><asp:HiddenField runat="server" ID='hdnItemCategorieID' Value='<%#Eval("CategorieID")%>' /><%#Eval("Categorie")%></div></ItemTemplate>
                                                        <EmptyListTemplate>Er zijn geen categorieën beschikbaar.</EmptyListTemplate>
                                                        <ReorderTemplate><div class="reorderitem"><asp:HiddenField runat="server" ID='hdnReOrderCategorieID' Value='<%#Eval("CategorieID")%>' /><%#Eval("Categorie")%></div></ReorderTemplate>
                                                        <EditItemTemplate>&nbsp;</EditItemTemplate>
                                                        <InsertItemTemplate>&nbsp;</InsertItemTemplate>
                                                        <DragHandleTemplate><img src="CSS/images/pin.png" /></DragHandleTemplate>
                                                        </cc1:ReorderList>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </table>
                                    </Content>
                                    </cc1:AccordionPane>
                                    <cc1:AccordionPane ID="PaneCategorieVerwijderen" runat="server">
                                        <Header>
                                            Categorie verwijderen</Header>
                                        <Content>
                                            <table>
                                                <tr>
                                                    <th align="left">
                                                        Categoriekeuze verfijnen
                                                    </th>
                                                </tr>
                                                <tr>
                                                    <td class="lbl">
                                                        <asp:Label ID="lblCatDelVersiekeuze" runat="server" Text="Filter op versie: "></asp:Label>
                                                    </td>
                                                    <td class="ietd">
                                                        <asp:DropDownList ID="ddlCatDelVersiekeuze" runat="server" DataTextField="Versie"
                                                            DataValueField="VersieID" Width="100%">
                                                        </asp:DropDownList>
                                                    </td>
                                                    <td>
                                                        <span style="vertical-align: middle" id='lbltipCatDelVersiekeuze'>
                                                            <img src="CSS/images/help.png" alt='' /></span>&#160;
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="lbl">
                                                        <asp:Label ID="lblCatDelTaalkeuze" runat="server" Text="Filter op taal: "></asp:Label>
                                                    </td>
                                                    <td class="ietd">
                                                        <asp:DropDownList ID="ddlCatDelTaalkeuze" runat="server" DataTextField="Taal" DataValueField="TaalID"
                                                            Width="100%">
                                                        </asp:DropDownList>
                                                    </td>
                                                    <td>
                                                        <span style="vertical-align: middle" id='tipCatDelTaalkeuze'>
                                                            <img src="CSS/images/help.png" alt='' /></span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="lbl">
                                                        <asp:Label ID="lblCatDelBedrijfkeuze" runat="server" Text="Filter op bedrijf: "></asp:Label>
                                                    </td>
                                                    <td class="ietd">
                                                        <asp:DropDownList ID="ddlCatDelBedrijfkeuze" runat="server" DataTextField="naam"
                                                            DataValueField="bedrijfID" Width="100%">
                                                        </asp:DropDownList>
                                                    </td>
                                                    <td>
                                                        <span style="vertical-align: middle" id='tipCatDelBedrijfkeuze'>
                                                            <img src="CSS/images/help.png" alt='' /></span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="lbl">
                                                        &#160;&#160;
                                                    </td>
                                                    <td>
                                                        <asp:Button ID="btnCatDelFilteren" runat="server" Text="Filteren" Width="100%" UseSubmitBehavior="false" /></asp:Button>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        &#160;&#160;
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <th align="left">
                                                        Categorie verwijderen
                                                    </th>
                                                </tr>
                                                <tr>
                                                    <td class="lbl">
                                                        <asp:Label ID="lblCatVerwijder" runat="server" Text="Categorie: "></asp:Label>
                                                    </td>
                                                    <td class="ietd">
                                                        <asp:DropDownList ID="ddlCatVerwijder" runat="server" DataTextField="Categorie" DataValueField="CategorieID"
                                                            Width="100%">
                                                        </asp:DropDownList>
                                                        <asp:Label runat="server" ID="lblCatVerwijderGeenCats" Text="Er zijn geen categorieën beschikbaar."
                                                            Visible="false"></asp:Label>
                                                    </td>
                                                    <td>
                                                        <span style="vertical-align: middle" id='tipCatVerwijder'>
                                                            <img src="CSS/images/help.png" alt='' /></span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                <td>
                                                Alle artikels en subcategoriëen onder deze categorie verwijderen: 
                                                </td>
                                                <td><asp:CheckBox ID="ckbAllesCategorie" runat="server" /></td>
                                                    
                                                </tr>
                                                <tr>
                                                    <td>
                                                        &#160;&#160;
                                                    </td>
                                                    <td>
                                                        <asp:Button ID="btnCatDelete" runat="server" Text="Verwijderen" Width="100%" />
                                                    </td>
                                                    <td>
                                                        <asp:Image runat="server" ID="imgResDelete" ImageUrl="~/App_Presentation/CSS/images/spacer.gif" />&nbsp;<asp:Label
                                                            ID="lblResDelete" runat="server" Text=""></asp:Label>
                                                    </td>
                                                </tr>
                                            </table>
                                        </Content>
                                    </cc1:AccordionPane>
                                </Panes>
                            </cc1:Accordion>
                            <asp:UpdateProgress ID="UpdateProgress3" runat="server">
                                <ProgressTemplate>
                                    <div class="update">
                                        <img src="CSS/Images/ajaxloader.gif" />
                                        Even wachten aub...
                                    </div>
                                </ProgressTemplate>
                            </asp:UpdateProgress>
    </ContentTemplate>
</asp:UpdatePanel>
            </ContentTemplate>
</cc1:TabPanel>
            <cc1:TabPanel runat="server"  ID="tabVideo" HeaderText="Video">
            <HeaderTemplate>
Video
            </HeaderTemplate>
<ContentTemplate>
            <asp:UpdatePanel ID="updVideo" runat="server">
                        <ContentTemplate>
                            <cc1:Accordion ID="accordionVideo" runat="server" SelectedIndex="0" HeaderCssClass="art-BlockHeaderStrong"
                                ContentCssClass="art-content">
                                <Panes>
                                    <cc1:AccordionPane runat="server" BackColor="Black" ID="paneVideoBeheren">
                                        <Header>
                                            Video's beheren</Header>
                                        <Content>
                                            <table>
                                                <tr>
                                                    <td colspan="2">
                                                        <input type="button" value="Video's Beheren" onclick="CKFinder.Popup( 'JS/ckfinder/', null, null, null ) ;" />
                                                    </td>
                                                    <td>
                                                        <span style="vertical-align: middle" id='tipVideoBeheren'>
                                                            <img src="CSS/images/help.png" alt='' /></span>
                                                    </td>
                                                </tr>
                                            </table>
                                        </Content>
                                    </cc1:AccordionPane>
                                    <cc1:AccordionPane runat="server" BackColor="Black" ID="paneVideoPreview">
                                        <Header>
                                            Videopreview</Header>
                                        <Content>
                                        <asp:UpdatePanel runat="server" ID="updPreviewLinkUpdaten" OnLoad="updPreviewLinkUpdaten_Load">
                                        <ContentTemplate>
                                            <table>
                                                <tr>
                                                    <td colspan="2">
                                                        <input type="button" value="Video Selecteren" onclick="CKFinder.Popup( 'JS/ckfinder/', null, null, videoSelectieInvullenInPreview ) ;" />
                                                        <script type="text/javascript">
                                                        function videoSelectieInvullenInPreview( fileUrl, data )
                                                        {
                                                            var link = document.getElementById("<%= lblVideoPreviewLink.ClientID %>");
                                                            if( link )
                                                            {
                                                                link.value = fileUrl;
                                                                __doPostBack('<%= updPreviewLinkUpdaten.ClientID %>', '');
                                                            }
                                                        }
                                                        </script> </td>
                                                    <td>
                                                        <span style="vertical-align: middle" id='tipVideoPreviewKiezen'>
                                                            <img src="CSS/images/help.png" alt='' /></span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                <td class="lbl">
                                                    <asp:Label runat="server" ID="lblVideoPreview" text="Preview-link: "></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:HiddenField runat="server" ID="lblVideoPreviewLink" />
                                                    <a href="#" runat="server" id="linkVideoPreview" rel="shadowbox" >Preview Tonen</a>
                                                </td>
                                                <td>
                                                        <span style="vertical-align: middle" id='tipVideoPreview'>
                                                            <img src="CSS/images/help.png" alt='' /></span>
                                                </td>
                                                </tr>
                                            </table>
                                            </ContentTemplate>
                                           </asp:UpdatePanel>
                                        </Content>
                                    </cc1:AccordionPane>
                                </Panes>
                            </cc1:Accordion>
                            <asp:UpdateProgress ID="UpdateProgress5" runat="server">
                                <ProgressTemplate>
                                    <div class="update">
                                        <img src="CSS/Images/ajaxloader.gif" />
                                        Even wachten aub...
                                    </div>
                                </ProgressTemplate>
                            </asp:UpdateProgress>
                        </ContentTemplate>
                    </asp:UpdatePanel>
            </ContentTemplate>
</cc1:TabPanel>
            <cc1:TabPanel runat="server" ID="tabOnderhoud" HeaderText="Applicatie-Onderhoud">
                <HeaderTemplate>
                    Applicatie-Onderhoud
            </HeaderTemplate>
<ContentTemplate>
                    <asp:UpdatePanel ID="updOnderhoud" runat="server">
                        <ContentTemplate>
                            <cc1:Accordion ID="AccordionOnderhoud" runat="server" SelectedIndex="0" HeaderCssClass="art-BlockHeaderStrong"
                                ContentCssClass="art-content">
                                <Panes>
                                    <cc1:AccordionPane runat="server" BackColor="Black" ID="PaneTrees">
                                        <Header>
                                            Boomstructuren</Header>
                                        <Content>
                                            <table>
                                                <tr>
                                                    <th align="left">
                                                        Boomstructuur-info
                                                    </th>
                                                </tr>
                                                <tr>
                                                    <td class="lbl">
                                                        <asp:Label ID="lblTreesAantalInfo" runat="server" Text="Aantal boomstructuren: "></asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:Label ID="lblTreesAantal" runat="server"></asp:Label>
                                                    </td>
                                                    <td>
                                                        <span style="vertical-align: middle" id='tipTreesAantal'>
                                                            <img src="CSS/images/help.png" alt='' /></span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="lbl">
                                                        <asp:Label ID="lblTreesAantalCatsInfo" runat="server" Text="Aantal categorieën: "></asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:Label ID="lblTreesAantalCats" runat="server"></asp:Label>
                                                    </td>
                                                    <td>
                                                        <span style="vertical-align: middle" id='tipTreesAantalCats'>
                                                            <img src="CSS/images/help.png" alt='' /></span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="lbl">
                                                        <asp:Label ID="lblTreesAantalArtsInfo" runat="server" Text="Aantal artikels: "></asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:Label ID="lblTreesAantalArts" runat="server"></asp:Label>
                                                    </td>
                                                    <td>
                                                        <span style="vertical-align: middle" id='tipTreesAantalArts'>
                                                            <img src="CSS/images/help.png" alt='' /></span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <th align="left">
                                                        Boomstructuur weergeven
                                                    </th>
                                                </tr>
                                                <tr>
                                                    <td class="lbl">
                                                        <asp:Label ID="lblTreesWeergeven" runat="server" Text="Kies een boomstructuur: "></asp:Label>
                                                    </td>
                                                    <td class="ietd">
                                                        <asp:DropDownList runat="server" ID="ddlTreesWeergeven" Width="100%" >
                                                        </asp:DropDownList>
                                                    </td>
                                                    <td>
                                                        <span style="vertical-align: middle" id='tipTreesWeergeven'>
                                                            <img src="CSS/images/help.png" alt='' /></span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        &#160;&nbsp;
                                                    </td>
                                                    <td>
                                                        <asp:Button runat="server" ID="btnTreeWeergeven" Text="Weergeven" Width="100%" />
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <th align="left">
                                                        Boomstructuren herbouwen
                                                    </th>
                                                </tr>
                                                <tr>
                                                    <td colspan="2">
                                                        <div>
                                                            <img src="CSS/images/warning.png" />&nbsp;<u><b>Opgelet:</b></u> De boomstructuren
                                                            herbouwen is een intensieve operatie en kan verschillende minuten duren.<br />
                                                            Gedurende deze operatie is geen enkele pagina beschikbaar.</div>
                                                    </td>
                                                    <td>
                                                        <span style="vertical-align: middle" id='tipTreesHerbouwen'>
                                                            <img src="CSS/images/help.png" alt='' /></span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        &#160;&nbsp;
                                                    </td>
                                                    <td>
                                                        <input type="button" id="btnTreesHerbouwen" value="Herbouwen" runat="server" />
                                                        <cc1:ModalPopupExtender ID="mpeTreesHerbouwen" runat="server" TargetControlID="btnTreesHerbouwen"
                                                            PopupControlID="modalpopup" BackgroundCssClass="modalBackground" CancelControlID="btnCancel">
                                                        </cc1:ModalPopupExtender>
                                                        <asp:Panel ID="modalpopup" runat="server" CssClass="modalPopup">
                                                            <div style="text-align: center;" id="divHerbouwTreesConfirmatie" runat="server">
                                                                Bent u zeker dat u de boomstructuren wilt herbouwen?
                                                                <br></br>
                                                                <asp:UpdatePanel runat="server" ID="updHerbouwTreesConfirmatie" UpdateMode="Conditional">
                                                                    <ContentTemplate>
                                                                        <asp:Button runat="server" ID="btnOk" Text="Ja"/><asp:Button runat="server" ID="btnCancel"
                                                                            Text="Annuleer" /></ContentTemplate>
                                                                </asp:UpdatePanel>
                                                            </div>
                                                        </asp:Panel>
                                                    </td>
                                                </tr>
                                                                                                <tr>
                                                    <td>
                                                        &#160;&nbsp;
                                                    </td>
                                                    <td><asp:Image runat="server" ID="imgHerbouwTreesRes" ImageUrl="~/App_Presentation/CSS/images/spacer.gif" />&nbsp;<asp:Label runat="server" ID="lblHerbouwTreesRes"></asp:Label></td>
                                                </tr>
                                            </table>
                                        </Content>
                                    </cc1:AccordionPane>
                                    <cc1:AccordionPane runat="server" BackColor="Black" ID="AccordionTooltip">
                                        <Header>
                                            Tooltips</Header>
                                        <Content>
                                            <table>
                                                <tr>
                                                    <th align="left">
                                                        Tooltip-info
                                                    </th>
                                                </tr>
                                                <tr>
                                                    <td class="lbl">
                                                        <asp:Label ID="lblAantalTooltipsInfo" runat="server" Text="Aantal tooltips: "></asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:Label ID="lblAantalTooltips" runat="server"></asp:Label>
                                                    </td>
                                                    <td>
                                                        <span style="vertical-align: middle" id='tipAantalTooltips'>
                                                            <img src="CSS/images/help.png" alt='' /></span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <th align="left">
                                                        Tooltips herladen
                                                    </th>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        &#160;&nbsp;
                                                    </td>
                                                    <td>
                                                        <asp:Button runat="server" ID="btnHerlaadTooltips" Text="Herladen" />
                                                    </td>
                                                    <td>
                                                        <span style="vertical-align: middle" id='tipHerlaadTooltips'>
                                                            <img src="CSS/images/help.png" alt='' /></span>
                                                    </td>
                                                </tr>
                                                                                                <tr>
                                                    <td>
                                                        &#160;&nbsp;
                                                    </td>
                                                    <td><asp:Image runat="server" ID="imgHerlaadTooltipsRes"  ImageUrl="~/App_Presentation/CSS/images/spacer.gif" />&nbsp;<asp:Label runat="server" ID="lblHerlaadTooltipsRes"></asp:Label></td>
                                                </tr>
                                            </table>
                                        </Content>
                                    </cc1:AccordionPane>
                                    <cc1:AccordionPane runat="server" BackColor="Black" ID="AccordionLokalisatie">
                                        <Header>
                                            Lokalisatie</Header>
                                        <Content>
                                            <table>
                                                <tr>
                                                    <th align="left">
                                                        Lokalisatie-info
                                                    </th>
                                                </tr>
                                                <tr>
                                                    <td class="lbl">
                                                        <asp:Label ID="lblAantalTalenInfo" runat="server" Text="Aantal gelokaliseerde talen: "></asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:Label ID="lblAantalTalen" runat="server"></asp:Label>
                                                    </td>
                                                    <td>
                                                        <span style="vertical-align: middle" id='tipAantalTalen'>
                                                            <img src="CSS/images/help.png" alt='' /></span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="lbl">
                                                        <asp:Label ID="lblAantalStringsInfo" runat="server" Text="Aantal gelokaliseerde teksten: "></asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:Label ID="lblAantalStrings" runat="server"></asp:Label>
                                                    </td>
                                                    <td>
                                                        <span style="vertical-align: middle" id='tipAantalTeksten'>
                                                            <img src="CSS/images/help.png" alt='' /></span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <th align="left">
                                                        Gelokaliseerde taal weergeven
                                                    </th>
                                                </tr>
                                                <tr>
                                                    <td class="lbl">
                                                        <asp:Label ID="lblTaalWeergeven" runat="server" Text="Kies een taal: "></asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:DropDownList runat="server" ID="ddlTaalWeergeven" Width="100%" >
                                                        </asp:DropDownList>
                                                    </td>
                                                    <td>
                                                        <span style="vertical-align: middle" id='tipTaalWeergeven'>
                                                            <img src="CSS/images/help.png" alt='' /></span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        &#160;&nbsp;
                                                    </td>
                                                    <td>
                                                        <asp:Button runat="server" ID="btnTaalWeergeven" Text="Weergeven" Width="100%" />
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <th align="left">
                                                        Lokalisatie herladen
                                                    </th>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        &#160;&nbsp;
                                                    </td>
                                                    <td>
                                                        <asp:Button runat="server" ID="btnLokalisatieHerladen" Text="Herladen" Width="100%" />
                                                    </td>
                                                    <td>
                                                        <span style="vertical-align: middle" id='tipLokalisatieHerladen'>
                                                            <img src="CSS/images/help.png" alt='' /></span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        &#160;&nbsp;
                                                    </td>
                                                    <td><asp:Image runat="server" id="imgLokalisatieHerladenRes"  ImageUrl="~/App_Presentation/CSS/images/spacer.gif" />&nbsp;<asp:Label runat="server" ID="lblLokalisatieHerladenRes"></asp:Label></td>
                                                </tr>
                                            </table>
                                        </Content>
                                    </cc1:AccordionPane>
                                </Panes>
                            </cc1:Accordion>
                            <asp:UpdateProgress ID="UpdateProgress4" runat="server">
                                <ProgressTemplate>
                                    <div class="update">
                                        <img src="CSS/Images/ajaxloader.gif" />
                                        Even wachten aub...
                                    </div>
                                </ProgressTemplate>
                            </asp:UpdateProgress>

                            <script type="text/javascript"> 

        function pageLoad(sender, args)
        {
            //An array of the behavior IDs of each modal popup
            var modalPopups = ['mpeBouwTrees'];

            AddHiddenEventToPopups(modalPopups);
        }

        function AddHiddenEventToPopups(modalPopups)
        {
            //step through the popups
            for (var i=0; i < modalPopups.length; i++)
            {
                //find the current popup
                var popUp = $find(modalPopups[i]);

                //check it exists so the script won't fail
                if (popUp)
                {
                    //Add the function below as the event
                    popUp.add_hidden(HidePopupPanel);
                }
             }
        }

        function HidePopupPanel(source, args)
        {
            //find the panel associated with the extender
            objPanel = document.getElementById(source._PopupControlID);

            //check the panel exists
            if (objPanel)
            {
                //set the display attribute, so it remains hidden on postback
                objPanel.style.display= 'none';
            }
        }

                            </script> </ContentTemplate>
                    </asp:UpdatePanel>
                
                
            
                
                
            
            </ContentTemplate>
            



</cc1:TabPanel>
        </cc1:TabContainer>
    </div>
</asp:Content>
