<%@ Page Language="VB" MasterPageFile="~/App_Presentation/MasterPage.master" AutoEventWireup="false" CodeFile="OnderhoudUitvoeren.aspx.vb" Inherits="App_Presentation_Webpaginas_Beheer_NieuwOnderhoud" title="Untitled Page" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="plcMain" Runat="Server">

<h1><asp:Label ID="lblHoofdTitel" runat="server"></asp:Label></h1>

    <asp:UpdatePanel ID="updVolledigFormulier" runat="server">
    <ContentTemplate>

<div runat="server" id="divVolledigFormulier">

Onderhoudsdatum:&nbsp;<asp:Label ID="lblOnderhoudsDatum" runat="server"></asp:Label><br />
<br />



<h2>Beschadigingen</h2>

<asp:UpdatePanel runat="server" ID="updBeschadigingsoverzicht" UpdateMode="Always">
                <ContentTemplate>
                    <asp:Label ID="lblGeenBeschadigingen" runat="server" Visible="false"></asp:Label>
                <div runat="server" id="divBeschadigingsoverzicht">
                  <table>
                    <tr>
                        <th>Beschadigings<br />nummer</th>
                        <th>Klant die de<br />beschadiging toebracht</th>
                        <th>Datum van<br />opmerking</th>
                        <th>Omschrijving</th>
                        <th>Is hersteld?</th>
                        <th>Herstellingskost</th>
                        <th>Oude beschadiging</th>
                        <th>Foto</th>
                    </tr> 
                    <asp:Repeater ID="repBeschadigingsOverzicht" runat="server">
                    <ItemTemplate>
                    <tr>
                        <td align="center"><%#DataBinder.Eval(Container.DataItem, "BeschadigingID")%></td>
                        <td align="center"><%#DataBinder.Eval(Container.DataItem, "KlantNaamVoornaam")%></td>
                        <td align="center"><%#(CType(Container.DataItem, System.Data.DataRowView)("DatumOpmerking")).ToShortDateString()%></td>
                        <td align="center"><%#DataBinder.Eval(Container.DataItem, "Omschrijving")%></td>
                        <td align="center"><%#DataBinder.Eval(Container.DataItem, "IsHersteld")%></td>
                        <td align="center"><%#DataBinder.Eval(Container.DataItem, "Herstellingskost")%></td>
                        <td align="center"><%#DataBinder.Eval(Container.DataItem, "IsOudeBeschadiging")%></td>
                        <td align="center"><img alt="Foto van beschadiging" src="../../AutoFotoBeschadiging.ashx?beschadigingID=<%#DataBinder.Eval(Container.DataItem, "beschadigingID")%>"</td>
                    </tr> 
                    </ItemTemplate>
                    </asp:Repeater>
                  </table>
                  </div>
                        </ContentTemplate>
                    </asp:UpdatePanel>
            
    <br /><br />
<cc1:Accordion ID="Beschadigingsaccordion" runat="server" AutoSize="None" TransitionDuration="250" headercssclass="art-BlockHeaderStrong">
        <Panes>
        <cc1:AccordionPane ID="PaneBeschadigingToevoegen" runat="server">
                <Header>Beschadiging Toevoegen</Header>
                    <content>
                <asp:UpdatePanel runat="server" ID="updBeschadigingToevoegen" UpdateMode="Always">
                    <ContentTemplate>
                            <table>
                                <tr>
                                    <td>
                                      Klant die de<br />
                                      beschadiging toebracht  
                                    </td>
                                    <td>
                                        <asp:DropDownList ID="ddlKlantNieuweBeschadiging" runat="server"></asp:DropDownList>
                                        <asp:Label ID="lblRecentsteKlant" runat="server" Visible="false">
                                            <asp:Label ID="lblRecentsteKlantUserID" runat="server" Visible="false"></asp:Label></asp:Label><br />
                                        <asp:CheckBox ID="chkLaatsteKlantWasVerantwoordelijk" Text="De klant van de meest recente reservatie heeft deze beschadiging aangebracht" runat="server" AutoPostBack="true" /><br />
                                        <asp:CheckBox ID="chkGeenKlant" runat="server" Text="Deze beschadiging werd niet door een klant veroorzaakt" AutoPostBack="true" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        Datum van<br />
                                        opmerking
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtDatumOpmerkingNieuweBeschadiging" runat="server" CausesValidation="True"></asp:TextBox>
                                        <cc1:CalendarExtender ID="calBegindatum" runat="server" TargetControlID="txtDatumOpmerkingNieuweBeschadiging"
                                            Format="d/MM/yyyy" FirstDayOfWeek="Monday" TodaysDateFormat="d MMMM, yyyy" PopupButtonID="imgBeginDatumKalender">
                                        </cc1:CalendarExtender>
                                        <asp:Image ImageAlign="AbsMiddle" ID="imgBeginDatumKalender" runat="server" ImageUrl="~/App_Presentation/Images/kalender.png" />
                                        <asp:RequiredFieldValidator ID="valBegindatum" runat="server" ControlToValidate="txtDatumOpmerkingNieuweBeschadiging"
                                            ErrorMessage="Dit veld is verplicht."></asp:RequiredFieldValidator>
                                        <cc1:MaskedEditExtender ID="mskBeginDatum" runat="server" TargetControlID="txtDatumOpmerkingNieuweBeschadiging"
                                            Mask="99/99/9999" MaskType="Date" MessageValidatorTip="False" PromptCharacter="."
                                            ClearMaskOnLostFocus="False" ClearTextOnInvalid="True">
                                        </cc1:MaskedEditExtender>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        Omschrijving
                                    </td>
                                    <td>
                                        <textarea id="txtOmschrijvingNieuweBeschadiging" runat="server" cols="20" rows="3"></textarea>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        Foto
                                    </td>
                                    <td>
                                        <cc1:AsyncFileUpload ID="fupFotoBeschadiging" runat="server" OnUploadedComplete="FotoGeupload" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        Beschadiging is<br />hersteld
                                    </td>
                                    <td>
                                        <asp:CheckBox ID="chkIsHersteldNieuweBeschadiging" AutoPostBack="true" runat="server" />
                                    </td>
                                </tr>                                
                                <tr>
                                    <td>
                                        <asp:Label ID="lblKostNieuweBeschadiging" runat="server" Text="Beschadigingskost" Visible="false"></asp:Label>
                                    </td>
                                    <td>
                                        <asp:textbox ID="txtKostNieuweBeschadiging" runat="server" Visible="false"></asp:textbox>
                                    </td>
                                </tr>
                            </table>
                            <div align="center">
                            <asp:Button ID="btnBeschadigingToevoegen" runat="server" Text="Beschadiging Toevoegen" />
                            </div>
                            <div align="center" runat="server" id="divBeschToevoegenFeedback" visible="false">
                            <br />
                                <asp:Image ID="imgBeschToevoegenFeedback" runat="server" />&nbsp;<asp:Label ID="lblBeschToevoegenFeedback" runat="server" ></asp:Label>
                                <br /><br />
                            </div>
                    </ContentTemplate>
                    <Triggers>
                        <asp:AsyncPostBackTrigger ControlID="btnBeschadigingToevoegen" />
                    </Triggers>
                </asp:UpdatePanel>
                </Content>
            </cc1:AccordionPane>
        <cc1:AccordionPane ID="PaneBeschadigingWijzigen" runat="server">
                <Header>Beschadiging Wijzigen</Header>
                <Content>
                    <asp:UpdatePanel runat="server" ID="updBeschadigingWijzigen" UpdateMode="Always">
                        <ContentTemplate>
                            <asp:Label ID="lblBeschadigingWijzigenKanNiet" runat="server" Text="Deze auto heeft momenteel geen beschadigingen." Visible="false"></asp:Label>
                        <div runat="server" id="divBeschadigingWijzigen">
                            <table>
                                <tr>
                                    <td>
                                       Selecteer Beschadiging: 
                                    </td>
                                    <td>
                                        <asp:DropDownList ID="ddlBeschadigingen" runat="server" AutoPostBack="true"></asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                      Klant die de<br />
                                      beschadiging toebracht  
                                    </td>
                                    <td>
                                        <asp:CheckBox ID="chkNietDoorKlantAangericht" runat="server" Text="Niet door een klant aangericht" AutoPostBack="true" /><br />
                                        <asp:DropDownList ID="ddlKlanten" runat="server"></asp:DropDownList>
                                        <asp:Label Visible="false" ID="lblWijzigBeschGeenKlantenTeKiezen" runat="server" Text="Op de datum van dit onderhoud heeft nog geen enkele klant deze auto ingecheckt."></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        Datum van<br />opmerking
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtDatumVanOpmerking" runat="server" CausesValidation="True"></asp:TextBox>
                                        <cc1:CalendarExtender ID="calDatumVanOpmerking" runat="server" TargetControlID="txtDatumVanOpmerking"
                                            Format="d/MM/yyyy" FirstDayOfWeek="Monday" TodaysDateFormat="d MMMM, yyyy" PopupButtonID="imgBeginDatumKalender">
                                        </cc1:CalendarExtender>
                                        <asp:Image ImageAlign="AbsMiddle" ID="imgDatumVanOpmerking" runat="server" ImageUrl="~/App_Presentation/Images/kalender.png" />
                                        <asp:RequiredFieldValidator ID="valDatumVanOpmerking" runat="server" ControlToValidate="txtDatumVanOpmerking"
                                            ErrorMessage="Dit veld is verplicht."></asp:RequiredFieldValidator>
                                        <cc1:MaskedEditExtender ID="mskDatumVanOpmerking" runat="server" TargetControlID="txtDatumVanOpmerking"
                                            Mask="99/99/9999" MaskType="Date" MessageValidatorTip="False" PromptCharacter="."
                                            ClearMaskOnLostFocus="False" ClearTextOnInvalid="True">
                                        </cc1:MaskedEditExtender>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        Omschrijving
                                    </td>
                                    <td>
                                        <textarea id="txtOmschrijving" runat="server" cols="20" rows="3"></textarea>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        Beschadiging is<br />hersteld
                                    </td>
                                    <td>
                                        <asp:CheckBox ID="chkIsHersteld" AutoPostBack="true" runat="server" />
                                    </td>
                                </tr>                                
                                <tr>
                                    <td>
                                        <asp:Label ID="lblHerstellingskost" runat="server" Text="Beschadigingskost"></asp:Label>
                                    </td>
                                    <td>
                                        <asp:textbox ID="txtHerstellingskost" runat="server"></asp:textbox>
                                    </td>
                                </tr>
                            </table>
                            <div align="center">
                             <asp:Button ID="btnBeschadigingWijzigen" runat="server" Text="Wijzig Beschadiging" />
                            </div>
                            <div align="center" runat="server" id="divBeschWijzigenFeedback" visible="false">
                            <br />
                                <asp:Image ID="imgBeschWijzigenFeedback" runat="server" />&nbsp;<asp:Label ID="lblBeschWijzigenFeedback" runat="server" ></asp:Label>
                                <br /><br />
                            </div>
                        </div>
                        </ContentTemplate>
                        <Triggers>
                            <asp:AsyncPostBackTrigger ControlID="ddlBeschadigingen" />
                        </Triggers>
                    </asp:UpdatePanel>
                </Content>
            </cc1:AccordionPane>
        <cc1:AccordionPane ID="PaneBeschadigingVerwijderen" runat="server">
                <Header>Beschadiging Verwijderen</Header>
                <Content>
                    <asp:UpdatePanel ID="updBeschadigingVerwijderen" runat="server" UpdateMode="Always">
                    <ContentTemplate>
                     <asp:Label ID="lblBeschadigingVerwijderenKanNiet" runat="server" Text="Deze auto heeft momenteel geen beschadigingen."></asp:Label>
                    <div runat="server" id="divBeschadigingVerwijderen">
                    <table>
                    <tr>
                    <td>Selecteer beschadiging:</td>
                    <td><asp:DropDownList ID="ddlBeschadigingenVerwijderen" runat="server"></asp:DropDownList></td>
                    </tr>
                    </table>
                    <div align="center">
                    <asp:Button ID="btnBeschadigingVerwijderen" runat="server" Text="Beschadiging Verwijderen" />
                    </div>
                    <div align="center" runat="server" id="divBeschVerwijderenFeedback" visible="false">
                            <br />
                                <asp:Image ID="imgBeschVerwijderenFeedback" runat="server" />&nbsp;<asp:Label ID="lblBeschVerwijderenFeedback" runat="server" ></asp:Label>
                                <br /><br />
                            </div>
                    </div>
                    </ContentTemplate>
                    </asp:UpdatePanel>
                </Content>
            </cc1:AccordionPane>
        </Panes>
    </cc1:Accordion>

<h2>Onderhoudsacties</h2>

    <asp:UpdatePanel ID="updOnderhoudsActieOverzicht" runat="server">
    <ContentTemplate>
    <asp:Label ID="lblGeenOnderhoudsActies" runat="server" Text="Er zijn momenteel geen onderhoudsacties bij dit onderhoud." Visible="false"></asp:Label>
    <div runat="server" id="divOnderhoudsActieOverzicht">
                  <table>
                    <tr>
                        <th>Actienummer</th>
                        <th>Onderhoudsactie</th>
                        <th>Kost</th>
                    </tr> 
                    <asp:Repeater ID="RepOnderhoudsActies" runat="server">
                    <ItemTemplate>
                    <tr>
                        <td align="center"><%#DataBinder.Eval(Container.DataItem, "actieID")%></td>
                        <td align="center"><%#DataBinder.Eval(Container.DataItem, "actieOmschrijving")%></td>
                        <td align="center"><%#DataBinder.Eval(Container.DataItem, "actieKost")%></td>
                    </tr> 
                    </ItemTemplate>
                    </asp:Repeater>
                    </table>
                    </div>
    </ContentTemplate>
    </asp:UpdatePanel>
                    
    <br /><br />
     <cc1:Accordion ID="OnderhoudsactieAccordion" runat="server" AutoSize="None" TransitionDuration="250" headercssclass="art-BlockHeaderStrong">
        <Panes>
        <cc1:AccordionPane ID="PaneOnderhoudsActieToevoegen" runat="server">
                <Header>Onderhoudsactie Toevoegen</Header>
                    <content>
                <asp:UpdatePanel runat="server" ID="updOnderhoudsActieToevoegen" UpdateMode="Always">
                    <ContentTemplate>

                            <table>
                                <tr>
                                <th colspan="2">Onderhoudsactie toevoegen</th>
                                </tr>
                                <tr>
                                <td align="right"><asp:RadioButton ID="rdbStandaardActieToevoegen" GroupName="StandaardActiesToevoegen" runat="server" checked="true" Text="Standaardactie:" AutoPostBack="true" /></td>
                                <td><asp:DropDownList ID="ddlPrefabOnderhoudsActies" runat="server" DataTextField="actieOmschrijving" DataValueField="actieID" AutoPostBack="true"></asp:DropDownList></td>
                                </tr>
                                <tr>
                                <td align="right"><asp:RadioButton ID="rdbAndereActieToevoegen" GroupName="StandaardActiesToevoegen" runat="server" Text="Andere actie:" AutoPostBack="true" /></td>
                                <td><asp:TextBox ID="txtAndereOnderhoudsActie" runat="server" Enabled="false"></asp:TextBox></td>
                                </tr>
                                <tr>
                                <td align="right">Kost:</td>
                                <td><asp:TextBox ID="txtKostOnderhoudsActie" runat="server" Enabled="false"></asp:TextBox></td>
                                </tr>
                                <tr>
                                <td colspan="2">
                                    <asp:Button ID="btnOnderhoudsActieToevoegen" runat="server" Text="Onderhoudsactie Toevoegen" /></td>
                                </tr>
                                </table>
                    </ContentTemplate>
                    <Triggers>
                        <asp:AsyncPostBackTrigger ControlID="btnOnderhoudsActieToevoegen" />
                    </Triggers>
                </asp:UpdatePanel>
                </Content>
            </cc1:AccordionPane>
        <cc1:AccordionPane ID="PaneOnderhoudsActieWijzigen" runat="server">
                <Header>Onderhoudsactie Wijzigen</Header>
                <Content>
                    <asp:UpdatePanel runat="server" ID="updOnderhoudsActieWijzigen" UpdateMode="Always">
                        <ContentTemplate>
                            <asp:Label ID="lblOnderhoudsActiesWijzigenKanNiet" runat="server" Text="Er zijn momenteel geen onderhoudsacties bij dit onderhoud."  Visible="false"></asp:Label>
                        <div runat="server" id="divOnderhoudsActieWijzigen">
                            <table>
                                <tr>
                                <td>Selecteer onderhoudsactie:</td>
                                <td>
                                <asp:DropDownList ID="ddlOnderhoudsActieWijzigen" runat="server" AutoPostBack="true"></asp:DropDownList>
                                </td>
                                </tr>
                                <tr>
                                <td align="right"><asp:RadioButton ID="rdbStandaardActieWijzigen" GroupName="StandaardActiesWijzigen" runat="server" checked="true" Text="Standaardactie:" AutoPostBack="true" /></td>
                                <td><asp:DropDownList ID="ddlPrefabOnderhoudsActiesWijzigen" runat="server" DataTextField="actieOmschrijving" DataValueField="actieID" AutoPostBack="true"></asp:DropDownList></td>
                                </tr>
                                <tr>
                                <td align="right"><asp:RadioButton ID="rdbAndereActieWijzigen" GroupName="StandaardActiesWijzigen" runat="server" Text="Andere actie:" AutoPostBack="true" /></td>
                                <td><asp:TextBox ID="txtAndereActieWijzigen" runat="server" Enabled="false"></asp:TextBox></td>
                                </tr>
                                <tr>
                                <td align="right">Kost:</td>
                                <td><asp:TextBox ID="txtOnderhoudskostWijzigen" runat="server" Enabled="false"></asp:TextBox></td>
                                </tr>
                                <tr>
                                <td colspan="2">
                                    <asp:Button ID="btnOnderhoudsActieWijzigen" runat="server" Text="Onderhoudsactie Wijzigen" /></td>
                                </tr>
                                </table>
                                </div>
                        </ContentTemplate>
                        <Triggers>
                            <asp:AsyncPostBackTrigger ControlID="ddlOnderhoudsActieWijzigen" />
                        </Triggers>
                    </asp:UpdatePanel>
                </Content>
            </cc1:AccordionPane>
        <cc1:AccordionPane ID="PaneOnderhoudsActieVerwijderen" runat="server">
                <Header>Onderhoudsactie Verwijderen</Header>
                <Content>
                    <asp:UpdatePanel ID="updOnderhoudsActieVerwijderen" runat="server" updatemode="always">
                    <ContentTemplate>
                                            <asp:Label ID="lblOnderhoudsActieVerwijderenKanNiet" runat="server" Text="Er zijn momenteel geen onderhoudsacties bij dit onderhoud." Visible="false"></asp:Label>
                    <div runat="server" id="divOnderhoudsActieVerwijderen">
                    <table>
                    <tr>
                    <td>Selecteer onderhoudsactie:</td>
                    <td><asp:DropDownList ID="ddlOnderhoudsActiesVerwijderen" runat="server"></asp:DropDownList></td>
                    </tr>
                    <tr>
                    <td colspan="2" align="right">
                        <asp:Button ID="btnOnderhoudsActieVerwijderen" runat="server" Text="Onderhoudsactie Verwijderen" /></td>
                    </tr>
                    </table>
                    </div>
                    </ContentTemplate>
                    </asp:UpdatePanel>
                </Content>
            </cc1:AccordionPane>
        </Panes>
    </cc1:Accordion>
     
<h2>Nazicht</h2>               
    <asp:UpdatePanel ID="updNazicht" runat="server">
    <ContentTemplate>
    
        <asp:CheckBox runat="server" id="chkIsNazicht" autopostback="true" Text="Dit is een nazicht."></asp:CheckBox>
        <asp:Label ID="lblNazichtIsOnmogelijk" runat="server" visible="false"></asp:Label>
        <div runat="server" id="divNazichtOpties" visible="false">
        
        <table>
        <asp:PlaceHolder runat="server" ID="plcGeenReservatieID"></asp:PlaceHolder>
        <tr>
        <td>Parkeerplaats</td>
        <td>
            <asp:UpdatePanel ID="updParkeeroverzicht" runat="server">
            <ContentTemplate>
        <asp:Label ID="lblNazichtParkeerPlaats" runat="server" Text="Geen parkeerplaats"></asp:Label>
        <asp:TextBox ID="txtAutoParkeerplaats" runat="server" Text='<%# Bind("autoParkeerplaats") %>' Visible="false" />
        <asp:ImageButton ID="imgParkeerPlaats" runat="server" ImageUrl="~/App_Presentation/Images/kalender.png" />
        <asp:UpdateProgress ID="progress1" runat="server" AssociatedUpdatePanelID="updParkeeroverzicht">
        <ProgressTemplate>
        
            <div class="progress">
                <img src="../../Images/ajax-loader.gif" />
                Even wachten aub...
            </div>
        
        </ProgressTemplate>
        </asp:UpdateProgress>
        <br />
        <asp:Label ID="lblGeenOverzicht" runat="server" Visible="false"></asp:Label>
        <asp:PlaceHolder ID="plcParkingLayout" runat="server"></asp:PlaceHolder>
           </ContentTemplate>     
             </asp:UpdatePanel>
        </td>
        </tr>
        <tr>
        <th>Brandstofkost</th>
        </tr>
        <tr>
        <td>Inhoud van tank:</td>
        <td><asp:Label ID="lblNazichtTankInhoud" runat="server"></asp:Label></td>
        </tr>
        <tr>
        <td>Tank bij inchecken:</td>
        <td><asp:TextBox ID="txtNazichtTankNaInchecken" runat="server"></asp:TextBox><asp:Button
                ID="btnBerekenBrandstofKost" runat="server" Text="Bereken" /></td>
        </tr>
        <tr>
        <td>Berekende kost:</td>
        <td><asp:Label ID="lblNazichtBerekendeBrandstofkost" runat="server"></asp:Label></td>
        </tr>
        <tr>
            <th>
                Kilometerstand</th>
            <tr>
                <td>
                    Vorige kilometerstand:</td>
                <td>
                    <asp:Label ID="lblNazichtVorigKilometerstand" runat="server"></asp:Label>
                </td>
            </tr>
            <tr>
                <td>
                    Huidige kilometerstand:</td>
                <td>
                    <asp:TextBox ID="txtNazichtHuidigeKilometerstand" runat="server" AutoPostBack="true"></asp:TextBox>
                </td>
            </tr>
            <tr>
            <td colspan="2">
                <div runat="server" id="divOlieMoetVerversdWorden" visible="false">
                    <img src="../../Images/warning.png" />&nbsp;De olie van deze auto dient verversd te worden.
                </div>
            </td>
            </tr>
        </table>
        
        </div>
   </ContentTemplate>     
    </asp:UpdatePanel>
    <br /><br />
    <asp:UpdatePanel ID="updOnderhoudOpslaan" runat="server">
        <ContentTemplate>
                <div align="center">
                <asp:Button ID="btnOnderhoudOpslaan" runat="server" Text="Onderhoud Opslaan" />
                </div>
                <div align="center" runat="server" id="divOnderhoudOpslaanFeedback" visible="false">
                <br /><asp:Image ID="imgOlieNietVerversd" runat="server" Visible="false" ImageUrl="~\App_Presentation\Images\warning.png" />&nbsp;<asp:Label ID="lblOlieNietVerversd" runat="server" Text="De olie van deze auto werd niet vervangen." Visible="false"></asp:Label>
                <br />
                <asp:Image ID="imgOnderhoudOpslaanFeedback" runat="server" />&nbsp;<asp:Label ID="lblOnderhoudOpslaanFeedback" runat="server"></asp:Label>
                <br />
                <br />
            </div>
            <div align="center">
            <asp:LinkButton ID="lnkTerugNaarOnderhoudsbeheer" runat="server" PostBackUrl="~/App_Presentation/Webpaginas/Beheer/Onderhoudbeheer.aspx">Terug Naar Onderhoudsbeheer</asp:LinkButton>
            </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel> 

</div>
        <asp:Label ID="lblFoutiefID" runat="server" Visible = "false"></asp:Label>

</ContentTemplate>
    </asp:UpdatePanel>

</asp:Content>

