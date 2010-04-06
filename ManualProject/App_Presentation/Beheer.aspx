<%@ Page Language="VB" MasterPageFile="~/App_Presentation/MasterPage.master" AutoEventWireup="false"
    CodeFile="Beheer.aspx.vb" Inherits="App_Presentation_Beheer" Title="Untitled Page" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
<div id="divLoggedIn" runat="server">    
<cc1:TabContainer runat="server" ID="TabContainer" ActiveTabIndex="2">
        <cc1:TabPanel runat="server" HeaderText="Bedrijf" ID="tabBedrijf">
            <HeaderTemplate>
                Bedrijf
        
        
        </HeaderTemplate>
        

<ContentTemplate>
                <asp:UpdatePanel ID="updBedrijf" runat="server"><ContentTemplate>
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
                                                    <asp:TextBox ID="txtAddbedrijf" runat="server"></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="vleAddBedrijf" runat="server" ErrorMessage="Gelieve een bedrijfsnaam in te geven." 
                                                    ControlToValidate="txtAddbedrijf" Display="None" ValidationGroup="bedrijfToevoegen"></asp:RequiredFieldValidator>
                                                    <cc1:ValidatorCalloutExtender ID="extAddBedrijf" runat="server" TargetControlID="vleAddBedrijf"></cc1:ValidatorCalloutExtender>
                                                    <span style="vertical-align:middle" id='tipAddBedrijf'><img src="CSS/images/help.png" alt=''/></span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="lbl">
                                                    <asp:Label ID="lblBedrijf" runat="server" Text="Tag: "></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txtAddTag" runat="server"></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="vleAddTag" runat="server" ErrorMessage="Gelieve een tag in te geven." 
                                                    ControlToValidate="txtAddTag" Display="None" ValidationGroup="bedrijfToevoegen"></asp:RequiredFieldValidator>
                                                    <cc1:ValidatorCalloutExtender ID="extAddTag" runat="server" TargetControlID="vleAddTag"></cc1:ValidatorCalloutExtender>
                                                    <span style="vertical-align:middle" id='tipAddTag'><img src="CSS/images/help.png" alt=''/></span>
                                                    <cc1:FilteredTextBoxExtender ID="fltAddTag" runat="server" FilterType="Custom, Numbers, UppercaseLetters, LowercaseLetters" 
                                                    TargetControlID="txtAddTag"  ValidChars="_"></cc1:FilteredTextBoxExtender>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Button ID="btnAddBedrijf" runat="server" Text="Toevoegen" ValidationGroup="bedrijfToevoegen" />
                                                </td>
                                                <td>
                                                    <asp:Label ID="lblAddBedrijfRes" runat="server" Text=""></asp:Label>
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
                                                <td>
                                                    <asp:DropDownList ID="ddlBewerkBedrijf" runat="server" DataSourceID="objdBedrijf"
                                                        DataTextField="naam" DataValueField="bedrijfID" OnSelectedIndexChanged="ddlBewerkBedrijf_SelectedIndexChanged"
                                                        AutoPostBack="true">
                                                    </asp:DropDownList>
                                                    <span style="vertical-align:middle" id='tipBewerkBedrijf'><img src="CSS/images/help.png" alt=''/></span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="lbl">
                                                    <asp:Label ID="lblEditBedrijf" runat="server" Text="Bedrijfsnaam: "></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txtEditBedrijf" runat="server"></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="vleEditBedrijf" runat="server" ErrorMessage="Gelieve een bedrijfsnaam in te geven." 
                                                    ControlToValidate="txtEditBedrijf" Display="None" ValidationGroup="bedrijfWijzigen"></asp:RequiredFieldValidator>
                                                    <cc1:ValidatorCalloutExtender ID="extEditBedrijf" runat="server" TargetControlID="vleEditBedrijf"></cc1:ValidatorCalloutExtender>
                                                    <span style="vertical-align:middle" id='tipEditBedrijf'><img src="CSS/images/help.png" alt=''/></span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <tr>
                                                    <td class="lbl">
                                                        <asp:Label ID="lblEditTag" runat="server" Text="Tag: "></asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:TextBox ID="txtEditTag" runat="server"></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="vleEditTag" runat="server" ErrorMessage="Gelieve een tag in te geven." 
                                                    ControlToValidate="txtEditTag" Display="None" ValidationGroup="bedrijfWijzigen"></asp:RequiredFieldValidator>
                                                    <cc1:ValidatorCalloutExtender ID="extEditTag" runat="server" TargetControlID="vleEditTag"></cc1:ValidatorCalloutExtender>
                                                    <span style="vertical-align:middle" id='tipEditTag'><img src="CSS/images/help.png" alt=''/></span>
                                                    <cc1:FilteredTextBoxExtender ID="fltEditTag" runat="server" FilterType="Custom, Numbers, UppercaseLetters, LowercaseLetters" 
                                                    TargetControlID="txtEditTag"  ValidChars="_"></cc1:FilteredTextBoxExtender>
                                                    </td>
                                                </tr>
                                                <td>
                                                    <asp:Button ID="btnEditBedrijf" runat="server" Text="Wijzig" ValidationGroup="bedrijfWijzigen" />
                                                </td>
                                                <td>
                                                    <asp:Label ID="lblEditbedrijfRes" runat="server" Text=""></asp:Label>
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
                                                <td>
                                                    <asp:DropDownList ID="ddlDeleteBedrijf" runat="server" DataSourceID="objdBedrijf"
                                                        DataTextField="naam" DataValueField="bedrijfID">
                                                    </asp:DropDownList>
                                                    <span style="vertical-align:middle" id='tipDeleteBedrijf'><img src="CSS/images/help.png" alt=''/></span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Button ID="btnDeleteBedrijf" runat="server" Text="Verwijder" />
                                                </td>
                                                <td>
                                                    <asp:Label ID="lblDeleteBedrijfRes" runat="server" Text=""></asp:Label>
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
                <asp:UpdatePanel ID="updTaal" runat="server"><ContentTemplate>
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
                                                    <asp:TextBox ID="txtAddTaal" runat="server"></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="vleAddTaal" runat="server" ErrorMessage="Gelieve een taal in te geven." 
                                                    ControlToValidate="txtAddTaal" Display="None" ValidationGroup="taalToevoegen"></asp:RequiredFieldValidator>
                                                    <cc1:ValidatorCalloutExtender ID="extAddTaal" runat="server" TargetControlID="vleAddTaal"></cc1:ValidatorCalloutExtender>
                                                    <span style="vertical-align:middle" id='tipAddTaal'><img src="CSS/images/help.png" alt=''/></span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="lbl">
                                                    <asp:Label ID="lblAfkorting" runat="server" Text="Afkorting: "></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txtTaalAfkorting" runat="server"></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="vleTaalAfkorting" runat="server" ErrorMessage="Gelieve een afkorting in te geven." 
                                                    ControlToValidate="txtTaalAfkorting" Display="None" ValidationGroup="taalToevoegen"></asp:RequiredFieldValidator>
                                                    <cc1:ValidatorCalloutExtender ID="extTaalAfkorting" runat="server" TargetControlID="vleTaalAfkorting"></cc1:ValidatorCalloutExtender>
                                                    <span style="vertical-align:middle" id='tipTaalAfkorting'><img src="CSS/images/help.png" alt=''/></span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Button ID="btnAddTaal" runat="server" Text="Toevoegen" ValidationGroup="taalToevoegen" />
                                                </td>
                                                <td>
                                                    <asp:Label ID="lblAddTaalRes" runat="server" Text=""></asp:Label>
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
                                                <td>
                                                    <asp:DropDownList ID="ddlBewerkTaal" runat="server" DataSourceID="objdTaal" DataTextField="Taal"
                                                        DataValueField="TaalID" OnSelectedIndexChanged="ddlBewerkTaal_SelectedIndexChanged"
                                                        AutoPostBack="true">
                                                    </asp:DropDownList>
                                                    <span style="vertical-align:middle" id='tipBewerkTaal'><img src="CSS/images/help.png" alt=''/></span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="lbl">
                                                    <asp:Label ID="lblEditTaal" runat="server" Text="Taal: "></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txtEditTaal" runat="server"></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="vleEditTaal" runat="server" ErrorMessage="Gelieve een taal in te geven." 
                                                    ControlToValidate="txtEditTaal" Display="None" ValidationGroup="taalWijzigen"></asp:RequiredFieldValidator>
                                                    <cc1:ValidatorCalloutExtender ID="extEditTaal" runat="server" TargetControlID="vleEditTaal"></cc1:ValidatorCalloutExtender>
                                                    <span style="vertical-align:middle" id='tipEditTaal'><img src="CSS/images/help.png" alt=''/></span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="lbl">
                                                    <asp:Label ID="lblEditAfkorting" runat="server" Text="Afkorting: "></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txtEditAfkorting" runat="server"></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="vleEditAfkorting" runat="server" ErrorMessage="Gelieve een afkorting in te geven." 
                                                    ControlToValidate="txtEditAfkorting" Display="None" ValidationGroup="taalWijzigen"></asp:RequiredFieldValidator>
                                                    <cc1:ValidatorCalloutExtender ID="extEditAfkorting" runat="server" TargetControlID="vleEditAfkorting"></cc1:ValidatorCalloutExtender>
                                                    <span style="vertical-align:middle" id='tipEditAfkorting'><img src="CSS/images/help.png" alt=''/></span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Button ID="btnEditTaal" runat="server" Text="Wijzig" ValidationGroup="taalWijzigen" />
                                                </td>
                                                <td>
                                                    <asp:Label ID="lblEditTaalRes" runat="server" Text=""></asp:Label>
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
                                                <td>
                                                    <asp:DropDownList ID="ddlTaalDelete" runat="server" DataSourceID="objdTaal" DataTextField="taal"
                                                        DataValueField="TaalID">
                                                    </asp:DropDownList>
                                                     <span style="vertical-align:middle" id='tipTaalDelete'><img src="CSS/images/help.png" alt=''/></span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Button ID="btnTaalDelete" runat="server" Text="Verwijder" />
                                                </td>
                                                <td>
                                                    <asp:Label ID="lblDeleteTaalRes" runat="server" Text=""></asp:Label>
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
                                    <img src="CSS/Images/ajaxloader.gif"/>
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
                <asp:UpdatePanel ID="updVersie" runat="server"><ContentTemplate>
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
                                                    <asp:TextBox ID="txtAddVersie" runat="server"></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="vleAddVersie" runat="server" ErrorMessage="Gelieve een versienummer in te geven." 
                                                    ControlToValidate="txtAddVersie" Display="None" ValidationGroup="versieToevoegen"></asp:RequiredFieldValidator>
                                                    <cc1:ValidatorCalloutExtender ID="extAddVersie" runat="server" TargetControlID="vleAddVersie"></cc1:ValidatorCalloutExtender>
                                                    <span style="vertical-align:middle" id='tipAddVersie'><img src="CSS/images/help.png" alt=''/></span>
                                                    <cc1:FilteredTextBoxExtender ID="fltAddVersie" runat="server" FilterType="Custom, Numbers" 
                                                    TargetControlID="txtAddVersie" ValidChars=".">
                                                    </cc1:FilteredTextBoxExtender>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Button ID="btnAddVersie" runat="server" Text="Toevoegen" ValidationGroup="versieToevoegen" />
                                                </td>
                                                <td>
                                                    <asp:Label ID="lblAddVersieRes" runat="server" Text=""></asp:Label>
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
                                                <td>
                                                    <asp:DropDownList ID="ddlBewerkVersie" runat="server" DataSourceID="objdVersie" DataTextField="Versie"
                                                        DataValueField="VersieID" OnSelectedIndexChanged="ddlBewerkVersie_SelectedIndexChanged"
                                                        AutoPostBack="true">
                                                    </asp:DropDownList>
                                                    <span style="vertical-align:middle" id='tipBewerkVersie'><img src="CSS/images/help.png" alt=''/></span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="lbl">
                                                    <asp:Label ID="lblVersieWijzigen" runat="server" Text="Versie: "></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txtEditVersie" runat="server"></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="vleEditVersie" runat="server" ErrorMessage="Gelieve een versienummer in te geven." 
                                                    ControlToValidate="txtEditVersie" Display="None" ValidationGroup="versieWijzigen"></asp:RequiredFieldValidator>
                                                    <cc1:ValidatorCalloutExtender ID="extEditVersie" runat="server" TargetControlID="vleEditVersie"></cc1:ValidatorCalloutExtender>
                                                    <span style="vertical-align:middle" id='tipEditVersie'><img src="CSS/images/help.png" alt=''/></span>
                                                    <cc1:FilteredTextBoxExtender ID="fltEditVersie" runat="server" FilterType="Custom, Numbers" 
                                                    TargetControlID="txtEditVersie" ValidChars=".">
                                                    </cc1:FilteredTextBoxExtender>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Button ID="btnEditVersie" runat="server" Text="Edit" ValidationGroup="versieWijzigen" />
                                                </td>
                                                <td>
                                                    <asp:Label ID="lblEditVersieRes" runat="server" Text=""></asp:Label>
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
                                                <td>
                                                    <asp:DropDownList ID="ddlVersiekopieren" runat="server" DataSourceID="objdVersie" DataTextField="Versie"
                                                        DataValueField="VersieID" autopostback="true">
                                                    </asp:DropDownList>
                                                    <span style="vertical-align:middle" id='tipVersieKopieren'><img src="CSS/images/help.png" alt=''/></span>
                                                </td>
                                            </tr>
                                            <tr>
                                            <td>&nbsp;</td>
                                            </tr>
                                            <tr>
                                            <th align="left">Kopieergegevens</th>
                                            </tr>
                                            <tr>
                                                <td class="lbl">
                                                    <asp:Label ID="lblKopieVersieAantalCategorien" runat="server" Text="Aantal categorieën: "></asp:Label>
                                                    <span style="vertical-align:middle" id='tipAantalCategorien'><img src="CSS/images/help.png" alt=''/></span>
                                                </td>
                                                <td>
                                                   <asp:Label ID="lblKopieVersieAantalArtikels" runat="server" Text="Aantal artikels: "></asp:Label>
                                                   <span style="vertical-align:middle" id='tipAantalArtikels'><img src="CSS/images/help.png" alt=''/></span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="lbl">
                                                    <asp:Label ID="lblNaamNieuweVersieKopie" runat="server" Text="Naam van de nieuwe versie: "></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txtNaamNieuweVersieKopie" runat="server"></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="vleNaamNieuweVersieKopie" runat="server" ErrorMessage="Gelieve een versienummer in te geven." 
                                                    ControlToValidate="txtNaamNieuweVersieKopie" Display="None" ValidationGroup="versieKopieren"></asp:RequiredFieldValidator>
                                                    <cc1:ValidatorCalloutExtender ID="extNaamNieuweVersieKopie" runat="server" TargetControlID="vleNaamNieuweVersieKopie">
                                                    </cc1:ValidatorCalloutExtender>
                                                    <span style="vertical-align:middle" id='tipNaamVersieKopie'>
                                                    <img src="CSS/images/help.png" alt=''/></span>
                                                    <cc1:FilteredTextBoxExtender ID="fltNaamNieuweVersieKopie" runat="server" FilterType="Custom, Numbers" 
                                                    TargetControlID="txtNaamNieuweVersieKopie" ValidChars=".">
                                                    </cc1:FilteredTextBoxExtender>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Button ID="btnVersieKopieren" runat="server" Text="Kopiëren" ValidationGroup="versieKopieren" />
                                                </td>
                                                <td>
                                                    <asp:Label ID="lblVersieKopierenFeedback" runat="server" Text=""></asp:Label>
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
                                                <td>
                                                    <asp:DropDownList ID="ddlDeletVersie" runat="server" DataSourceID="objdVersie" DataTextField="versie"
                                                        DataValueField="versieID">
                                                    </asp:DropDownList>
                                                    <span style="vertical-align:middle" id='tipDeleteVersie'>
                                                    <img src="CSS/images/help.png" alt=''/></span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Button ID="btnDeleteVersie" runat="server" Text="Verwijder" />
                                                </td>
                                                <td>
                                                    <asp:Label ID="lblDeleteVersieRes" runat="server" Text=""></asp:Label>
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
        <cc1:TabPanel runat="server" HeaderText="Categorie" ID="TabCategorie">
            <HeaderTemplate>
                Categorie
        
        
        </HeaderTemplate>


<ContentTemplate>
                <asp:UpdatePanel ID="updCategorie" runat="server">
                    <ContentTemplate>
                        <cc1:Accordion ID="AccordionCategorie" runat="server" SelectedIndex="0" HeaderCssClass="art-BlockHeaderStrong"
                            ContentCssClass="art-content">
                            <Panes>
                                <cc1:AccordionPane ID="PaneCategorieToevoegen" runat="server" BackColor="Black">
                                    <Header>
                                        Categorie toevoegen</Header>
                                    <Content>
                                        <table>
                                            <tr>
                                                <td class="lbl">
                                                    <asp:Label ID="lblAddCatnaam" runat="server" Text="Categorienaam: "></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txtAddCatnaam" runat="server"></asp:TextBox>
                                                   <asp:RequiredFieldValidator ID="vleAddCatnaam" runat="server" ErrorMessage="Gelieve een categorienaam in te geven." 
                                                    ControlToValidate="txtAddCatnaam" Display="None" ValidationGroup="categorieToevoegen"></asp:RequiredFieldValidator>
                                                    <cc1:ValidatorCalloutExtender ID="extAddCatnaam" runat="server" TargetControlID="vleAddCatnaam"></cc1:ValidatorCalloutExtender>
                                                    <span style="vertical-align:middle" id='tipAddCatnaam'><img src="CSS/images/help.png" alt=''/></span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="lbl">
                                                    <asp:Label ID="lblAddHoogte" runat="server" Text="Kies een hoogte: "></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txtAddhoogte" runat="server"></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="vleAddhoogte" runat="server" ErrorMessage="Gelieve een geldige hoogte in te geven." 
                                                    ControlToValidate="txtAddhoogte" Display="None" ValidationGroup="categorieToevoegen"></asp:RequiredFieldValidator>
                                                    <cc1:ValidatorCalloutExtender ID="extAddhoogte" runat="server" TargetControlID="vleAddhoogte"></cc1:ValidatorCalloutExtender>
                                                    <span style="vertical-align:middle" id='tipAddhoogte'><img src="CSS/images/help.png" alt=''/></span>
                                                    <cc1:FilteredTextBoxExtender ID="fltAddhoogte" runat="server" FilterType="Numbers" 
                                                    TargetControlID="txtAddhoogte"></cc1:FilteredTextBoxExtender>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="lbl">
                                                    <asp:Label ID="lblAddCatVersie" runat="server" Text="Kies een versie: "></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:DropDownList ID="ddlAddCatVersie" runat="server" DataSourceID="objdVersie"
                                                        DataTextField="Versie" DataValueField="VersieID" AutoPostBack="true">
                                                    </asp:DropDownList>
                                                    <span style="vertical-align:middle" id='tipAddCatVersie'><img src="CSS/images/help.png" alt=''/></span>
                                                </td>
                                            </tr>
                                            <tr>
                                            <td class="lbl">
                                                <asp:Label ID="lblAddCatTaal" runat="server" Text="Kies een taal: "></asp:Label>
                                            </td>
                                            <td>
                                                <asp:DropDownList ID="ddlAddCatTaal" runat="server" DataSourceID="objdTaal" DataTextField="Taal"
                                                    DataValueField="TaalID" AutoPostBack="true">
                                                </asp:DropDownList>
                                                <span style="vertical-align:middle" id='tipAddCatTaal'><img src="CSS/images/help.png" alt=''/></span>
                                            </td>
                                            </tr>
                                            <tr>
                                                <td class="lbl">
                                                    <asp:Label ID="lblAddCatBedrijf" runat="server" Text="Kies een bedrijf: "></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:DropDownList ID="ddlAddCatBedrijf" runat="server" DataSourceID="objdBedrijf"
                                                        DataTextField="naam" DataValueField="bedrijfID" AutoPostBack="true">
                                                    </asp:DropDownList>
                                                    <span style="vertical-align:middle" id='tipAddCatBedrijf'><img src="CSS/images/help.png" alt=''/></span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="lbl">
                                                    <asp:Label ID="lblAddParentCat" runat="server" Text="Kies een Hoofdcategorie: "></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:DropDownList ID="ddlAddParentcat" runat="server"
                                                        DataTextField="Categorie" DataValueField="CategorieID" OnSelectedIndexChanged="ddlAddParentcat_SelectedIndexChanged"
                                                        AutoPostBack="True">
                                                    </asp:DropDownList>
                                                    <span style="vertical-align:middle" id='tipAddParentcat'><img src="CSS/images/help.png" alt=''/></span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Button ID="btnCatAdd" runat="server" Text="Voeg toe" ValidationGroup="categorieToevoegen"></asp:Button>
                                                </td>
                                                <td>
                                                    <asp:Label ID="lblResAdd" runat="server" Text=""></asp:Label>
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
                                            <th align="left">Categoriekeuze verfijnen</th>
                                            </tr>
                                            <tr>
                                                <td class="lbl">
                                                    <asp:Label ID="lblBewerkCatVersiekeuze" runat="server" Text="Filter op versie: "></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:DropDownList ID="ddlEditCatVersiekeuze" runat="server" DataSourceID="objdVersie"
                                                        DataTextField="Versie" DataValueField="VersieID">
                                                    </asp:DropDownList>
                                                    <span style="vertical-align:middle" id='tipEditCatVersiekeuze'><img src="CSS/images/help.png" alt=''/></span>
                                                </td>
                                            </tr>
                                            <tr>
                                            <td class="lbl">
                                                <asp:Label ID="lblBewerkCatTaalkeuze" runat="server" Text="Filter op taal: "></asp:Label>
                                            </td>
                                            <td>
                                                <asp:DropDownList ID="ddlEditCatTaalkeuze" runat="server" DataSourceID="objdTaal" DataTextField="Taal"
                                                    DataValueField="TaalID">
                                                </asp:DropDownList>
                                                <span style="vertical-align:middle" id='tipEditCatTaalkeuze'><img src="CSS/images/help.png" alt=''/></span>
                                            </td>
                                            </tr>
                                            <tr>
                                                <td class="lbl">
                                                    <asp:Label ID="lblBewerkCatBedrijfkeuze" runat="server" Text="Filter op bedrijf: "></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:DropDownList ID="ddlEditCatBedrijfkeuze" runat="server" DataSourceID="objdBedrijf"
                                                        DataTextField="naam" DataValueField="bedrijfID">
                                                    </asp:DropDownList>
                                                    <span style="vertical-align:middle" id='tipEditCatBedrijfkeuze'><img src="CSS/images/help.png" alt=''/></span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="lbl">
                                                    &nbsp;
                                                </td>
                                                <td>
                                                    <asp:Button ID="btnEditCatVerfijnen" runat="server" Text="Filteren"></asp:Button>
                                                </td>
                                            </tr>
                                            <tr>
                                            <td>&nbsp;</td>
                                            </tr>
                                            <tr>
                                            <th align="left">Categorie wijzigen</th>
                                            </tr>
                                            <tr>
                                                <td class="lbl">
                                                    <asp:Label ID="lblBewerkCategorie" runat="server" Text="Kies een categorie: "></asp:Label>
                                                </td>
                                                <td>
                                                <div runat="server" id="divEditCategorie">
                                                    <asp:DropDownList ID="ddlEditCategorie" DataTextField="Categorie" DataValueField="CategorieID" runat="server" OnSelectedIndexChanged="ddlEditCategorie_SelectedIndexChanged"
                                                        AutoPostBack="true">
                                                    </asp:DropDownList>
                                                    <span style="vertical-align:middle" id='tipEditCategorie'><img src="CSS/images/help.png" alt=''/></span>
                                                    </div>
                                                    <asp:label runat="server" ID="ddlEditCategorieGeenCats" Text="Er zijn geen categorieën beschikbaar." Visible="false"></asp:label>
                                                </td>
                                            </tr>
                                            <tr runat="server" id="trCatBewerkNaam">
                                                <td class="lbl">
                                                    <asp:Label ID="lblCatBewerkNaam" runat="server" Text="Categorienaam: "></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txtCatbewerknaam" runat="server"></asp:TextBox>
                                                   <asp:RequiredFieldValidator ID="vleCatbewerknaam" runat="server" ErrorMessage="Gelieve een categorienaam in te geven." 
                                                    ControlToValidate="txtCatbewerknaam" Display="None" ValidationGroup="categorieWijzigen"></asp:RequiredFieldValidator>
                                                    <cc1:ValidatorCalloutExtender ID="extCatbewerknaam" runat="server" TargetControlID="vleCatbewerknaam"></cc1:ValidatorCalloutExtender>
                                                    <span style="vertical-align:middle" id='tipCatbewerknaam'><img src="CSS/images/help.png" alt=''/></span>
                                                </td>
                                            </tr>
                                            <tr runat="server" id="trBewerkCatHoogte">
                                                <td class="lbl">
                                                    <asp:Label ID="lblBewerkHCatoogte" runat="server" Text="Kies een hoogte: "></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txtEditCathoogte" runat="server"></asp:TextBox>
                                                   <asp:RequiredFieldValidator ID="vleEditCathoogte" runat="server" ErrorMessage="Gelieve een geldige hoogte in te geven." 
                                                    ControlToValidate="txtEditCathoogte" Display="None" ValidationGroup="categorieWijzigen"></asp:RequiredFieldValidator>
                                                    <cc1:ValidatorCalloutExtender ID="extEditCathoogte" runat="server" TargetControlID="vleEditCathoogte"></cc1:ValidatorCalloutExtender>
                                                    <span style="vertical-align:middle" id='tipEditCatHoogte'><img src="CSS/images/help.png" alt=''/></span>
                                                </td>
                                            </tr>
                                            <tr>
                                            <td>&nbsp;</td>
                                            </tr>
                                            <tr>
                                            <th align="left">Categorie verplaatsen</th>
                                            </tr>
                                            <tr runat="server" id="trBewerkCatVersie">
                                                <td class="lbl">
                                                    <asp:Label ID="lblBewerkCatVersie" runat="server" Text="Kies een versie: "></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:DropDownList ID="ddlEditCatVersie" runat="server" DataSourceID="objdVersie"
                                                        DataTextField="Versie" DataValueField="VersieID" AutoPostBack="true">
                                                    </asp:DropDownList>
                                                    <span style="vertical-align:middle" id='tipEditCatVersie'><img src="CSS/images/help.png" alt=''/></span>
                                                </td>
                                            </tr>
                                            <tr runat="server" id="trBewerkCatTaal">
                                            <td class="lbl">
                                                <asp:Label ID="lblBewerkCatTaal" runat="server" Text="Kies een taal: "></asp:Label>
                                            </td>
                                            <td>
                                                <asp:DropDownList ID="ddlEditCatTaal" runat="server" DataSourceID="objdTaal" DataTextField="Taal"
                                                    DataValueField="TaalID" AutoPostBack="true">
                                                </asp:DropDownList>
                                                <span style="vertical-align:middle" id='tipEditCatTaal'><img src="CSS/images/help.png" alt=''/></span>
                                            </td>
                                            </tr>
                                            <tr runat="server" id="trBewerkCatBedrijf">
                                                <td class="lbl">
                                                    <asp:Label ID="lblBewerkCatBedrijf" runat="server" Text="Kies een bedrijf: "></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:DropDownList ID="ddlEditCatBedrijf" runat="server" DataSourceID="objdBedrijf"
                                                        DataTextField="naam" DataValueField="bedrijfID" AutoPostBack="true">
                                                    </asp:DropDownList>
                                                    <span style="vertical-align:middle" id='tipEditCatBedrijf'><img src="CSS/images/help.png" alt=''/></span>
                                                </td>
                                            </tr>
                                            <tr runat="server" id="trBewerkParentCat">
                                                <td class="lbl">
                                                    <asp:Label ID="lblBewerkParentCat" runat="server" Text="Kies een hoofdcategorie: "></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:DropDownList ID="ddlEditCatParent" runat="server"
                                                        DataTextField="Categorie" DataValueField="CategorieID" OnSelectedIndexChanged="ddlEditCatParent_SelectedIndexChanged"
                                                        AutoPostBack="true">
                                                    </asp:DropDownList>
                                                    <span style="vertical-align:middle" id='tipEditCatParent'><img src="CSS/images/help.png" alt=''/></span>
                                                </td>
                                            </tr>
                                            <tr runat="server" id="trCatEditButton">
                                                <td>
                                                    <asp:Button ID="btnCatEdit" runat="server" Text="Wijzig" ValidationGroup="categorieWijzigen"></asp:Button>
                                                </td>
                                                <td>
                                                    <asp:Label ID="lblResEdit" runat="server" Text=""></asp:Label>
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
                                            <th align="left">Categoriekeuze verfijnen</th>
                                            </tr>
                                            <tr>
                                                <td class="lbl">
                                                    <asp:Label ID="lblCatDelVersiekeuze" runat="server" Text="Filter op versie: "></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:DropDownList ID="ddlCatDelVersiekeuze" runat="server" DataSourceID="objdVersie"
                                                        DataTextField="Versie" DataValueField="VersieID">
                                                    </asp:DropDownList>
                                                    <span style="vertical-align:middle" id='lbltipCatDelVersiekeuze'><img src="CSS/images/help.png" alt=''/></span>
                                                </td>
                                            </tr>
                                            <tr>
                                            <td class="lbl">
                                                <asp:Label ID="lblCatDelTaalkeuze" runat="server" Text="Filter op taal: "></asp:Label>
                                            </td>
                                            <td>
                                                <asp:DropDownList ID="ddlCatDelTaalkeuze" runat="server" DataSourceID="objdTaal" DataTextField="Taal"
                                                    DataValueField="TaalID">
                                                </asp:DropDownList>
                                                <span style="vertical-align:middle" id='tipCatDelTaalkeuze'><img src="CSS/images/help.png" alt=''/></span>
                                            </td>
                                            </tr>
                                            <tr>
                                                <td class="lbl">
                                                    <asp:Label ID="lblCatDelBedrijfkeuze" runat="server" Text="Filter op bedrijf: "></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:DropDownList ID="ddlCatDelBedrijfkeuze" runat="server" DataSourceID="objdBedrijf"
                                                        DataTextField="naam" DataValueField="bedrijfID">
                                                    </asp:DropDownList>
                                                    <span style="vertical-align:middle" id='tipCatDelBedrijfkeuze'><img src="CSS/images/help.png" alt=''/></span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="lbl">
                                                    &nbsp;
                                                </td>
                                                <td>
                                                    <asp:Button ID="btnCatDelFilteren" runat="server" Text="Filteren"></asp:Button>
                                                </td>
                                            </tr>
                                            <tr>
                                            <td>&nbsp;</td>
                                            </tr>
                                            <tr>
                                            <th align="left">Categorie verwijderen</th>
                                            </tr>
                                            <tr>
                                                <td class="lbl">
                                                    <asp:Label ID="lblCatVerwijder" runat="server" Text="Categorie: "></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:DropDownList ID="ddlCatVerwijder" runat="server" DataTextField="Categorie" DataValueField="CategorieID">
                                                    </asp:DropDownList>
                                                    <asp:label runat="server" ID="lblCatVerwijderGeenCats" Text="Er zijn geen categorieën beschikbaar." Visible="false"></asp:label>
                                                    <span style="vertical-align:middle" id='tipCatVerwijder'><img src="CSS/images/help.png" alt=''/></span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Button ID="btnCatDelete" runat="server" Text="Verwijder"/>
                                                </td>
                                                <td>
                                                    <asp:Label ID="lblResDelete" runat="server" Text=""></asp:Label>
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
                                    <img src="CSS/Images/ajaxloader.gif"/>
                                    Even wachten aub...
                                </div>
                            </ProgressTemplate>
                        </asp:UpdateProgress>
                    </ContentTemplate>
                </asp:UpdatePanel>
            
            
        
            
            
        
        </ContentTemplate>
        

</cc1:TabPanel>
    </cc1:TabContainer>
    <asp:ObjectDataSource ID="objdBedrijf" runat="server" DeleteMethod="Delete" InsertMethod="Insert"
        OldValuesParameterFormatString="original_{0}" SelectMethod="GetData" TypeName="ManualTableAdapters.tblBedrijfTableAdapter"
        UpdateMethod="Update">
        <DeleteParameters>
            <asp:Parameter Name="Original_BedrijfID" Type="Int32" />
        </DeleteParameters>
        <UpdateParameters>
            <asp:Parameter Name="Naam" Type="String" />
            <asp:Parameter Name="Original_BedrijfID" Type="Int32" />
        </UpdateParameters>
        <InsertParameters>
            <asp:Parameter Name="BedrijfID" Type="Int32" />
            <asp:Parameter Name="Naam" Type="String" />
        </InsertParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="objdCategorie" runat="server" DeleteMethod="Delete" InsertMethod="Insert"
        OldValuesParameterFormatString="original_{0}" SelectMethod="GetData" TypeName="ManualTableAdapters.tblCategorieTableAdapter"
        UpdateMethod="Update">
        <DeleteParameters>
            <asp:Parameter Name="Original_CategorieID" Type="Int32" />
        </DeleteParameters>
        <UpdateParameters>
            <asp:Parameter Name="Categorie" Type="String" />
            <asp:Parameter Name="Diepte" Type="Int32" />
            <asp:Parameter Name="Hoogte" Type="Int32" />
            <asp:Parameter Name="FK_parent" Type="Int32" />
            <asp:Parameter Name="FK_taal" Type="Int32" />
            <asp:Parameter Name="Original_CategorieID" Type="Int32" />
        </UpdateParameters>
        <InsertParameters>
            <asp:Parameter Name="CategorieID" Type="Int32" />
            <asp:Parameter Name="Categorie" Type="String" />
            <asp:Parameter Name="Diepte" Type="Int32" />
            <asp:Parameter Name="Hoogte" Type="Int32" />
            <asp:Parameter Name="FK_parent" Type="Int32" />
            <asp:Parameter Name="FK_taal" Type="Int32" />
        </InsertParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="objdTaal" runat="server" DeleteMethod="Delete" InsertMethod="Insert"
        OldValuesParameterFormatString="original_{0}" SelectMethod="GetData" TypeName="ManualTableAdapters.tblTaalTableAdapter"
        UpdateMethod="Update">
        <DeleteParameters>
            <asp:Parameter Name="Original_TaalID" Type="Int32" />
        </DeleteParameters>
        <UpdateParameters>
            <asp:Parameter Name="Taal" Type="String" />
            <asp:Parameter Name="Original_TaalID" Type="Int32" />
        </UpdateParameters>
        <InsertParameters>
            <asp:Parameter Name="TaalID" Type="Int32" />
            <asp:Parameter Name="Taal" Type="String" />
        </InsertParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="objdVersie" runat="server" DeleteMethod="Delete" InsertMethod="Insert"
        OldValuesParameterFormatString="original_{0}" SelectMethod="GetData" TypeName="ManualTableAdapters.tblVersieTableAdapter"
        UpdateMethod="Update">
        <DeleteParameters>
            <asp:Parameter Name="Original_VersieID" Type="Int32" />
        </DeleteParameters>
        <UpdateParameters>
            <asp:Parameter Name="Versie" Type="String" />
            <asp:Parameter Name="Original_VersieID" Type="Int32" />
        </UpdateParameters>
        <InsertParameters>
            <asp:Parameter Name="VersieID" Type="Int32" />
            <asp:Parameter Name="Versie" Type="String" />
        </InsertParameters>
    </asp:ObjectDataSource>
    </div>
</asp:Content>
