﻿<%@ Page Language="VB" AutoEventWireup="false" CodeFile="NieuweReservatieAanmaken.aspx.vb" Inherits="App_Presentation_NieuweReservatieAanmaken" EnableEventValidation="false" MasterPageFile="~/App_Presentation/MasterPage.master" Title="Nieuwe Reservatie Aanmaken"%>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<%@ Register assembly="GMaps" namespace="Subgurim.Controles" tagprefix="cc2" %>



<asp:Content ID="Main" ContentPlaceHolderID="plcMain" runat="server">
<h1>Nieuwe reservatie aanmaken</h1>
    <div>
    <asp:UpdatePanel ID="updOverview" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
        <table>
        <tbody>
        <tr>
        <td>Autocategorie:</td>
        <td>
            <asp:DropDownList ID="ddlCategorie" runat="server">
            </asp:DropDownList>
            <cc1:CascadingDropDown ID="ccdCategorie" runat="server" Category="Categorie" 
                PromptText="Categorie" ServiceMethod="GeefCategorien" 
                TargetControlID="ddlCategorie" ServicePath="~/App_Presentation/WebServices/AutoService.asmx">
            </cc1:CascadingDropDown>
            <asp:Label ID="lblCategorieVerkeerd" runat="server"></asp:Label>
        </td>
        </tr>
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
        <td colspan="2"><span style="font-size:smaller; font-style:italic;">Verwacht formaat: dd / mm / jjjj</span></td>
        </tr>
        </tbody>
        </table>
        <asp:Label ID="lblDatumVerkeerd" runat="server"></asp:Label>
        <br /><br />
            <table>
                <tbody>
                    <tr>
                        <td colspan="2" align="center">
                            Prijsklasse (per dag):
                        </td>
                    </tr>
                    <tr>
                    <td valign="middle">Tussen 
                        <asp:TextBox ID="txtPrijsMin" runat="server"></asp:TextBox>&nbsp;en&nbsp;
                        <asp:TextBox ID="txtPrijsMax" runat="server"></asp:TextBox>&nbsp;euro
                        <cc1:FilteredTextBoxExtender ID="fltPrijsMin" runat="server" TargetControlID="txtPrijsMin" FilterType="Custom, Numbers" ValidChars=","></cc1:FilteredTextBoxExtender>
                        <cc1:FilteredTextBoxExtender ID="fltPrijsMax" runat="server" TargetControlID="txtPrijsMax" FilterType="Custom, Numbers" ValidChars=","></cc1:FilteredTextBoxExtender>
                        </td>
                    </tr>
                </tbody>
        </table>
        <br />
        Filteren op:<br />
        <table>
        <tbody>
        <tr>
        <td>Kleur</td>
        <td>Merk</td>
        <td>Filiaal</td>
        <td>Extra Opties</td>
        </tr>
        <tr>
        <td>
        <asp:DropDownList ID="ddlKleur" runat="server"></asp:DropDownList>
        <cc1:CascadingDropDown ID="ccdKleur" runat="server" Category="Kleur" 
                ParentControlID="ddlCategorie" PromptText="Kleur Kiezen..." 
                ServiceMethod="GeefKleurPerCategorie" 
                ServicePath="~/App_Presentation/WebServices/AutoService.asmx" TargetControlID="ddlKleur">
        </cc1:CascadingDropDown>
        </td>
        <td>
        <asp:DropDownList ID="ddlMerk" runat="server"></asp:DropDownList>
        <cc1:CascadingDropDown ID="ccdMerk" runat="server" Category="Merk" 
                ParentControlID="ddlCategorie" PromptText="Merk Kiezen..." 
                ServiceMethod="GeefMerkenVoorCategorie" 
                ServicePath="~/App_Presentation/WebServices/AutoService.asmx" TargetControlID="ddlMerk">
        </cc1:CascadingDropDown>
        </td>
        <td>
            <asp:DropDownList ID="ddlFiliaal" runat="server">
            </asp:DropDownList>
        </td>
        <td align="center">
            <asp:CheckBox ID="chkGeenExtraOpties" runat="server" AutoPostBack="true" Text="Ik wil geen extra opties" /><br />
            <asp:PlaceHolder ID="plcExtraOpties" runat="server"></asp:PlaceHolder>
        </td>
        </tr>
        </tbody>
        </table>

        <br />
            <asp:Button ID="btnToonOverzicht" Text="Geef beschikbare auto's" OnClientClick="GMap1.clearOverlays();" runat="server"/>
        <br />
        <br />
          
          <div runat="server" id="divOverzichtHeader" visible="false">    
        <h2>Beschikbare auto's in <asp:Label ID="lblFiliaalNaam" runat="server"></asp:Label>:</h2>
        </div>  
        <asp:PlaceHolder ID="plcOverzicht" runat="server"></asp:PlaceHolder>
            <br />
            <div runat="server" class=" art-Overzicht" id="divRepOverzicht">               
                <asp:Repeater ID="RepOverzicht" runat="server">
                    <ItemTemplate>
                        <div style="display: inline">
                            <a href="ReservatieBevestigen.aspx?autoID=<%# DataBinder.Eval(Container.DataItem, "autoID") %>&begindat=<%# DataBinder.Eval(Container.DataItem, "begindat") %>&einddat=<%# DataBinder.Eval(Container.DataItem, "einddat") %>">
                                                                
                                <table border="0">
                                <tr>
                                    <td colspan="2"><h3><%#DataBinder.Eval(Container.DataItem, "Naam")%></h3></td>
                                </tr>
                                <tr>
                                    <td rowspan="4"><img src="../../AutoFoto.ashx?autoID=<%# DataBinder.Eval(Container.DataItem, "autoID") %>" alt="foto" width="200" height="150" style="display:inline" /></td>
                                </tr>
                                <tr>
                                    <td><b>Aantal beschikbaar:</b> <%#DataBinder.Eval(Container.DataItem, "Aantal")%></td>
                                </tr>
                                <tr>
                                    <td colspan="3" align="right">
                                        <a href="ReservatieBevestigen.aspx?autoID=<%# DataBinder.Eval(Container.DataItem, "autoID") %>&begindat=<%# DataBinder.Eval(Container.DataItem, "begindat") %>&einddat=<%# DataBinder.Eval(Container.DataItem, "einddat") %>">Nu reserveren</a></td>
                                </tr>
                                </table>
                        </div>
                        <br />
                    </ItemTemplate>
                </asp:Repeater>
            </div>
            <asp:UpdateProgress ID="progress1" runat="server">
        <ProgressTemplate>
        
            <div class="progress">
                <img src="../Images/ajax-loader.gif" /> 
                Even wachten aub...
            </div>
        
        </ProgressTemplate>
    </asp:UpdateProgress>
            <asp:Label ID="lblGeenAutos" runat="server" Text="Er werden geen auto's gevonden die voldeden aan uw voorwaarden." Visible="false"></asp:Label>
        <br />
        
        <div runat="server" id="gmapdiv" visible="false">
        <h4>
            <asp:Label ID="lblGmapFilialen" runat="server" Text="Niet gevonden wat u zocht? Klik op de icoontjes op deze kaart om te zien wat onze andere filialen aanbieden:"></asp:Label></h4>
        <cc2:GMap ID="Gmap1" runat="server" />
        </div>
        </ContentTemplate>
        </asp:UpdatePanel>
        
        
    
    </div>
    <asp:ObjectDataSource ID="odsReservatie" runat="server" 
        DataObjectTypeName="Reservatie&amp;" DeleteMethod="DeleteReservatie" 
        InsertMethod="InsertReservatie" SelectMethod="GetAllReservaties" 
        TypeName="ReservatieBLL">
        <DeleteParameters>
            <asp:Parameter Name="reservatieID" Type="Int32" />
        </DeleteParameters>
    </asp:ObjectDataSource>
    <br />

    <asp:ObjectDataSource ID="odsFiliaal" runat="server" 
        DataObjectTypeName="Autos+tblFiliaalRow&amp;" DeleteMethod="DeleteFiliaal" 
        SelectMethod="GetAllFilialen" TypeName="FiliaalBLL" 
        UpdateMethod="UpdateFiliaal">
        <DeleteParameters>
            <asp:Parameter Name="filiaalID" Type="Int32" />
        </DeleteParameters>
    </asp:ObjectDataSource>
    <br />
    </asp:Content>